var url = require('url');

const csvtojson = require('csvtojson'); 
const mongodb = require('mongodb');



const fileName = "2021-05.csv";

var url = "mongodb://localhost:27017/SampleDb";

var dbConn;

mongodb.MongoClient.connect(url, {
    useUnifiedTopology: true,
}).then((client) => {
    console.log('DB Connected!');
    dbConn = client.db();
}).catch(err => {
    console.log("DB Connection Error: ${err.message}");
});

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
         arrayToInsert.push(oneRow);
     }
     //inserting into the table "bikeRoutes"
     var collectionName = 'bikeRoutes';
     
     var collection = dbConn.collection(collectionName);

     
     collection.insertMany(arrayToInsert, (err, result) => {
         if (err) console.log(err);
         if(result){
             console.log("Import CSV into database successfully.");
             
         }
     });

      
      
    });

     
