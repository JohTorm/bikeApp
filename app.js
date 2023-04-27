var mongoUrl = require('url');

const csvtojson = require('csvtojson'); 
const mongodb = require('mongodb');
const express = require('express')
const app = express()
const async = require('async')
const csvMerger = require('csv-merger');
var mongoUrl = "mongodb://localhost:27017/db";
const fs = require('fs')


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
            outputPath: "mergedCsv.csv", 
            writeOutput: true, 
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
                                    console.log("Collection deleted");
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
                     dbConn.collection("stationInfo").insertMany(arrayToInsert, (err, result) => {
                        if (err) {
                            console.log(err);
                            return res.sendStatus(500);
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
                                            console.log("Collection deleted");
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
                        

                        if(jsonObj[i]["Covered distance (m)"] > 9.5 && jsonObj[i]["Duration (sec)"] > 9.5) { 
                            arrayToInsert.push(oneRow);
                        }
                    }

                })

                collection.insertMany(arrayToInsert, async (err, result) => {
                    if (err) {
                        console.log(err);
                        return res.sendStatus(500);
                        
                    }
                    if(result){
                        console.log("Import CSV into database successfully.");
                        
                        const sizeMay = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-05/]}});

                        const sizeJune = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-06/]}});

                        const sizeJuly = await dbConn.collection("bikeRoutes").countDocuments({"departure": {$in:[/2021-07/]}});

                        const sizeStation = await dbConn.collection("stationInfo").countDocuments();

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
            
            await dbConn.collection("bikeRoutes").find(query).skip(size * (pageNumber - 1)).sort(sorting).limit(size).allowDiskUse(true).toArray(function(err, result) {
                if (err) {
                    console.log(err);
                }
                try {
                    res.json(result);
                } catch {
                    res.status(500).send()
                }
                });
   
        } catch {
            res.status(500).send()
        }
        
        })

        app.get("/bikeRoutes/size", async (req, res) => {
            
            
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
                        res.send(results);
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
        var fileName = "bikestationdata";
        await dbConn.listCollections().toArray(function(err, items) {
            items.forEach(element => {
                if(element.name == 'stationInfo') 
                { 
                    try {
                        dbConn.dropCollection("stationInfo", function(err, delOK) {
                            if (err) {
                                console.log(err);      
                                                            
                            }
                            if (delOK){ 
                                console.log("Collection deleted");
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

    var collectionName = 'stationInfo';
    var collection = await dbConn.collection(collectionName);

    await csvtojson()
    .fromFile("bikestationdata.csv")
    .then((jsonObj)=>{
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

    collection.insertMany(arrayToInsert, (err, result) => {
    if (err) {
        console.log(err);
        return res.sendStatus(500);
        
    }
    if(result){
        console.log("Import CSV into database successfully.");

        dbConn.collection(collectionName).find().skip(size * (pageNumber - 1)).sort(sorting).collation({ locale: "en_US", numericOrdering: true }).limit(size).allowDiskUse(true).toArray(function(err, result) {
            if (err) {
                console.log(err);  
            }
            try {
                res.json(result);
            } catch {
                res.status(500).send()
            }
        });  
        }
    });  
}) 

app.get('/station/info:id', async (req, res) => {
    
    let id = req.params.id

     avgDistance = 0;
    await dbConn.collection("bikeRoutes").aggregate([
        {
          $group: {
            _id: "",
            avg_val:{$avg:{$toDouble:"$distance"}}
          }
        }
      ]).toArray(function(err, result) {
        if (err) {
            console.log(err);  
        }
        try {
            avgDistance = result[0]["avg_val"];
        } catch {
            res.status(500).send()
        }
    });

    var avgDuration = 0;
    await dbConn.collection("bikeRoutes").aggregate([
        {
          $group: {
            _id: "",
            avg_val:{$avg:{$toDouble:"$duration"}}
          }
        }
      ]).toArray(function(err, result) {
        if (err) {
            console.log(err);  
        }
        try {
            avgDuration = result[0]["avg_val"];
        } catch {
            res.status(500).send()
        }
    })
    async.parallel([
        function(callback){
            dbConn.collection("bikeRoutes").aggregate([
                {
                    $match: {
                        depStatID: id
                    }
                },
                {
                  $group: {
                    _id: "depStatID",
                    avg_dist_dep:{$avg:{$toDouble:"$distance"}}
                  }
                }
              ]).toArray(function(err, result1) {
                if (err) {
                    console.log(err);  
                }
                else {
                   callback(err, result1);                    
                } 
            })
        },
        function(callback){
            dbConn.collection("bikeRoutes").aggregate([
                {
                    $match: {
                        retStatID: id
                    }
                },
                {
                  $group: {
                    _id: "retStatID",
                    avg_dist_ret:{$avg:{$toDouble:"$distance"}}
                  }
                }
              ]).toArray(function(err, result2) {
                if (err) {
                    console.log(err);  
                }
                else {
                   callback(err, result2);                    
                } 
            })
        },
        function(callback){
            dbConn.collection("bikeRoutes").aggregate([
                { $match: {'depStatID': id} },
                { $group: { _id: null, n_dep: { $sum: 1 } } }
             ])
            .toArray(function(err, result3) {
                if (err) {
                    console.log(err);  
                }
                else {
                   callback(err, result3);                    
                } 
            });
        },
        function(callback){
            dbConn.collection("bikeRoutes").aggregate([
                { $match: {'retStatID': id} },
                { $group: { _id: null, n_ret: { $sum: 1 } } }
             ])
            .toArray(function(err, result4) {
                if (err) {
                    console.log(err);  
                }
                else {
                   callback(err, result4);                    
                } 
            });
        }

        ],function(err,results){
            if(err){
                res.json({"status": "failed", "message": error.message})
            }else{
            
                res.send(results); 
            }
    });
}) 
            
    
