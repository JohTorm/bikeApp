var mongoUrl = require('url');
var url = require('url');

const csvtojson = require('csvtojson'); 
const mongodb = require('mongodb');
const express = require('express')
const app = express()
const async = require('async')

const csvMerger = require('csv-merger');



var mongoUrl = "mongodb://localhost:27017/SampleDb";

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
    try {
        //delete 'bikeRoutes' collection if exists
        dbConn.dropCollection("bikeRoutes", function(err, delOK) {
            if (err) {
                console.log(err);
                return res.sendStatus(500);
                
            }
            if (delOK){ 
                console.log("Collection deleted");
                return res.send('Loading data '  + '..');
                
            }
            
          });
        
        } catch {
            res.status(500).send()
        }

        options = {
            outputPath: "testi.csv", // string: path to the output CSV file
            writeOutput: true, // boolean: if true, the output will be written to a file, otherwise will be returned by the function 
        }
        try {
            await csvMerger.merge(["2021-05.csv","2021-06.csv","2021-07.csv"], options);
            var fileName =  options.outputPath;
        } catch {
            res.status(500).send()
        }

        
        
        try {
            var arrayToInsert = [];
            csvtojson().fromFile(fileName).then(source => {
                // Fetching the all data from each row
                for (var i = 0; i < source.length; i++) {
                    var oneRow = {
                        departure: source[i]["Departure"],
                        return: source[i]["Return"],
                        depStatID: source[i]["Departure station id"],
                        retStatName: source[i]["Return station name"],
                        retStatID: source[i]["Return station id"],
                        depStatName: source[i]["Departure station name"],
                        distance: source[i]["Covered distance (m)"],
                        duration: source[i]["Duration (sec)"]
                    };
                    //Only add data with distance over 10m and duration over 10 sec 
                    if(oneRow.distance > 10 && oneRow.duration > 10) arrayToInsert.push(oneRow);
                }
                
                //inserting into the table "bikeRoutes"
                var collectionName = 'bikeRoutes';
                var collection = dbConn.collection(collectionName);
            
                
                collection.insertMany(arrayToInsert, (err, result) => {
                    if (err) {
                        console.log(err);
                        //return res.sendStatus(500);
                        
                    }
                    if(result){
                        console.log("Import CSV into database successfully.");
                        
                        
                        
                    }
                });   
                });
            } catch {
                res.status(500).send()
            }
                
        
    
    
    

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

            var query =  { "return": {$in:[new RegExp(month)]} };
            await dbConn.collection("bikeRoutes").find(query).skip(size * (pageNumber - 1)).limit(size).toArray(function(err, result) {
                if (err) {
                    console.log(err);
                    
                }
                try {
                    res.json(result);
                    console.log("sent!");
                } catch {
                    res.status(500).send()
                }
                });

            
        } catch {
            res.status(500).send()
        }
        
        
    
        })

        app.get("/api", (req, res) => {
            res.json({ message: "Hello from server!" });
          });
    
