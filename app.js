var mongoUrl = require('url');
var url = require('url');

const csvtojson = require('csvtojson'); 
const mongodb = require('mongodb');
const express = require('express')
const app = express()
const async = require('async')

const csvMerger = require('csv-merger');

var regexp_quote = require("regexp-quote");

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
        
         
        options = {
            outputPath: "testi.csv", // string: path to the output CSV file
            writeOutput: true, // boolean: if true, the output will be written to a file, otherwise will be returned by the function 
        }
        await csvMerger.merge(["2021-05.csv","2021-06.csv","2021-07.csv"], options);
        var fileName =  options.outputPath;

        var arrayToInsert = [];
        
        await csvtojson().fromFile(fileName).then(source => {
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
                    return res.sendStatus(500);
                    
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

    app.get('/bikeRoutes/:month-:limit', async (req, res, next) => {
        try {
            var month ="2021-0"+ req.params.month; 
            var limitt = parseInt(req.params.limit);
            console.log(limitt);
            var query =  { "return": {$in:[new RegExp(month)]} };
            await dbConn.collection("bikeRoutes").find(query).limit(limitt).toArray(function(err, result) {
                if (err) {
                    console.log(err);
                    
                }
                try {
                    res.send(result);
                } catch {
                    res.status(500).send()
                }
                });
                    
            
        } catch {
            res.status(500).send()
        }
        
        
    
        })
    
