var mongoUrl = require('url');

const csvtojson = require('csvtojson'); 
const mongodb = require('mongodb');
const express = require('express')
const app = express()
const async = require('async')

const csvMerger = require('csv-merger');



var mongoUrl = "mongodb://localhost:27017/db";

const fs = require('fs')

const path = './testi.csv'

var dbConn;


const PORT = 3001
app.listen(PORT, () => {
    console.log(`Server running at ${PORT}`)
})

mongodb.MongoClient.connect(mongoUrl, {
    useUnifiedTopology: true,
}).then((client) => {
    console.log('DB Connected!');
    dbConn = client.db();
    
    
}).catch(err => {
    console.log("DB Connection Error: ${err.message}");
});

app.get('/bikeRoutes/load', async (req, res, next) => {
    

        options = {
            outputPath: "testi.csv", // string: path to the output CSV file
            writeOutput: true, // boolean: if true, the output will be written to a file, otherwise will be returned by the function 
        }

        if(!fs.existsSync(path)) {
            try {
                

                await csvMerger.merge(["2021-05.csv","2021-06.csv","2021-07.csv"], options);
                

                
                console.log("merge Complete!")
                

            } catch {
                res.status(500).send()
            }
        }

        var fileName =  options.outputPath;
        
        try {
            var arrayToInsert = [];
            console.log("123")

            await dbConn.listCollections().toArray(function(err, items)  {
                items.forEach(element => {
                    if(element.name == 'stationInfo') 
                    { 
                        try {
                            
                            dbConn.dropCollection("stationInfo", function(err, delOK) {
                                if (err) {
                                    console.log(err);                                   
                                }
                                if (delOK){ 
                                    console.log("Collection deleted 1");
                                }
                              });
                            
                        } catch {
                            res.status(500).send()
                        }
                    }
                })
          });    
        } catch {
            res.status(500).send()
        } 

        await csvtojson()
                    .fromFile("bikestationdata.csv")
                    .then((jsonObj)=>{
                        console.log(fileName);

                        for (var i = 0; i < jsonObj.length; i++) {
                            var oneRow = {
                                id: jsonObj[i]["ID"],
                                nimi: jsonObj[i]["Nimi"],
                                namn: jsonObj[i]["Namn"],
                                name: jsonObj[i]["Name"],
                                osoite: jsonObj[i]["Osoite"],
                                adress: jsonObj[i]["Adress"],
                                kaupunki: jsonObj[i]["Kaupunki"],
                                stad: jsonObj[i]["Stad"],
                                operaattori: jsonObj[i]["Operaattor"],
                                kapasiteetti: jsonObj[i]["Kapasiteet"],
                                x: jsonObj[i]["x"],
                                y: jsonObj[i]["y"],
                            };
                            
                            arrayToInsert.push(oneRow);
                        }
    
                    })
                    
                    dbConn.collection("stationInfo");
                    //inserting into the table "stationInfo"
                    
                     dbConn.collection("stationInfo").insertMany(arrayToInsert, (err, result) => {
                        console.log("TESTI TESTERIINO")

                        if (err) {
                            console.log(err);
                            //return res.sendStatus(500);
                            
                        }
                    });
            
                    arrayToInsert = [];

                
                    await dbConn.listCollections().toArray(function(err, items)  {
                        items.forEach(element => {
                            if(element.name == 'bikeRoutes') 
                            { 
                                try {
                                    
                                    dbConn.dropCollection("bikeRoutes", function(err, delOK) {
                                        if (err) {
                                            console.log(err);                                   
                                        }
                                        if (delOK){ 
                                            console.log("Collection deleted 2");
                                        }
                                      });
                                    
                                } catch {
                                    res.status(500).send()
                                }
                            }
                        })
                  });  
                    
                 

            var collectionName = 'bikeRoutes';
            var collection = await dbConn.collection(collectionName);

                await csvtojson()
                .fromFile(fileName)
                .then((jsonObj)=>{

                    for (var i = 0; i < jsonObj.length; i++) {
                        var oneRow = {
                            departure: jsonObj[i]["Departure"],
                            return: jsonObj[i]["Return"],
                            depStatID: jsonObj[i]["Departure station id"],
                            retStatName: jsonObj[i]["Return station name"],
                            retStatID: jsonObj[i]["Return station id"],
                            depStatName: jsonObj[i]["Departure station name"],
                            distance: jsonObj[i]["Covered distance (m)"],
                            duration: jsonObj[i]["Duration (sec)"]
                        };
                        

                        //Only add data with distance over 10m and duration over 10 sec
                        if(jsonObj[i]["Covered distance (m)"] > 9.5 && jsonObj[i]["Duration (sec)"] > 9.5) { 
                            arrayToInsert.push(oneRow);
                        }
                    }

                })

                //inserting into the table "bikeRoutes"
                collection.insertMany(arrayToInsert, async (err, result) => {
                    if (err) {
                        console.log(err);
                        //return res.sendStatus(500);
                        
                    }
                    if(result){
                        console.log("Import CSV into database successfully. 1");
                        
                        const sizeMay = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-05/]}});
                        console.log(sizeMay);

                        const sizeJune = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-06/]}});
                        console.log(sizeJune);

                        const sizeJuly = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-07/]}});
                        console.log(sizeJuly);

                        const sizeStation = await dbConn.collection("stationInfo").countDocuments();
                        console.log(sizeStation);

                        res.json({
                            sizeBikeJourneyMay : sizeMay,
                            sizeBikeJourneyJune : sizeJune,
                            sizeBikeJourneyJuly : sizeJuly,
                            sizeStationInfo : sizeStation
                        });
                    }
                }); 

                
            
                
        
    
    
    

    })

    app.get('/bikeRoutes/:month-:size-:pageNumber', async (req, res) => {
        try {
            var month ="2021-0"+ req.params.month; 
            var size = parseInt(req.params.size);
            var pageNumber = parseInt(req.params.pageNumber);
            
            if(pageNumber < 0 || pageNumber === 0) {
                response = {"error" : true,"message" : "invalid page number, should start with 1"};
                return res.json(response)
          }

            var query =  { "departure": {$in:[new RegExp(month)]} };
            var sorting = { "departure": 1};
            
            console.log(query);
            await dbConn.collection("bikeRoutes").find(query).skip(size * (pageNumber - 1)).sort(sorting).limit(size).allowDiskUse(true).toArray(function(err, result) {
                if (err) {
                    console.log(err);
                    
                }
                try {
                    res.json(result);
                    console.log("sent! " );
                } catch {
                    res.status(500).send()
                }
                });
   
        } catch {
            res.status(500).send()
        }
        
        })

        app.get("/bikeRoutes/size", async (req, res) => {
            
            /*
            await dbConn.collection("bikeRoutes").count({}, function(error, numOfDocs) {
                res.json().append({
                    sizeBikeRoutes: numOfDocs
                }); 
                
            });
            */
            async.parallel([
                function(callback){
                    dbConn.collection("bikeRoutes").count({}, function(error, result1) {
                        callback(error, result1);
                    });
                },
                function(callback){
                    dbConn.collection("stationInfo").count({}, function(error, result2) {
                        callback(error, result2);
                    });
                }
        
                ],function(err,results){
                    if(err){
                        res.json({"status": "failed", "message": error.message})
                    }else{
                        res.send(results); //both result1 and result2 will be in results
                    }
            });
                    

        });









            
        app.get('/station/:size-:pageNumber', async (req, res) => {
            var size = parseInt(req.params.size);
            var pageNumber = parseInt(req.params.pageNumber);

            if(pageNumber < 0 || pageNumber === 0) {
                response = {"error" : true,"message" : "invalid page number, should start with 1"};
                return res.json(response)
          }
          
          var sorting = { "id": 1};


            try {
                var arrayToInsert = [];
                console.log("123")
                
                var fileName = "bikestationdata";

                await dbConn.listCollections().toArray(function(err, items) {
                    items.forEach(element => {
                        if(element.name == 'stationInfo') 
                        { 
                            try {
                                //delete 'stationInfo' collection if exists
                                dbConn.dropCollection("stationInfo", function(err, delOK) {
                                    if (err) {
                                        console.log(err);      
                                                                    
                                    }
                                    if (delOK){ 
                                        console.log("Collection deleted");
                                    }
                                  });
                                
                            } catch {
                               // res.status(500).send()
                               console.log("1233")

                            }
                        }
                    })
              });    
            } catch {
                res.status(500).send()
            }
    
            var collectionName = 'stationInfo';
            var collection = await dbConn.collection(collectionName);

                console.log(fileName);


                   await csvtojson()
                    .fromFile("bikestationdata.csv")
                    .then((jsonObj)=>{
                        console.log(fileName);

                        for (var i = 0; i < jsonObj.length; i++) {
                            var oneRow = {
                                id: jsonObj[i]["ID"],
                                nimi: jsonObj[i]["Nimi"],
                                namn: jsonObj[i]["Namn"],
                                name: jsonObj[i]["Name"],
                                osoite: jsonObj[i]["Osoite"],
                                adress: jsonObj[i]["Adress"],
                                kaupunki: jsonObj[i]["Kaupunki"],
                                stad: jsonObj[i]["Stad"],
                                operaattori: jsonObj[i]["Operaattor"],
                                kapasiteetti: jsonObj[i]["Kapasiteet"],
                                x: jsonObj[i]["x"],
                                y: jsonObj[i]["y"],
                            };
                            
                            console.log("123..")

                            arrayToInsert.push(oneRow);
                        }
    
                    })
    
                    //inserting into the table "stationInfo"
                     collection.insertMany(arrayToInsert, (err, result) => {
                        if (err) {
                            console.log(err);
                            //return res.sendStatus(500);
                            
                        }
                        if(result){
                            console.log("Import CSV into database successfully.");
    
                            dbConn.collection(collectionName).find().skip(size * (pageNumber - 1)).sort(sorting).collation({ locale: "en_US", numericOrdering: true }).limit(size).allowDiskUse(true).toArray(function(err, result) {
                                if (err) {
                                    console.log(err);
                                    
                                }
                                try {
                                    res.json(result);
                                    console.log("sent! " );
                                } catch {
                                    res.status(500).send()
                                }
                                });
                            
                            
                            
                        }
                    }); 
                
            
            
        }) 

            
    
