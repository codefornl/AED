var fs = require('fs');
var stream = fs.createWriteStream("./geodata/aed.geojson", {flags:'a'});
var featurecollection = {
  "type": "FeatureCollection",
  "features": []
};
fs.readdir('./sourcedata/',function(err, files){
    if(err) throw err;
    var count = files.length;
    files.forEach(function(file){
      fs.readFile('./sourcedata/' + file,
       'utf8', function (err, data) {
        if (err) {
          console.log("Something wrong with: " + file);
        } else {
          try {
            var obj = JSON.parse(data);
            if(obj.length > 0){
              var out = [];
              for (var i = 0; i < obj.length; i++){
                var item = obj[i];
                var hours = item.openHoursSchema.split("; ");
                var geojson = {
                  "type": "Feature",
                  "geometry": item.position,
                  "properties": {
                    "id": item._id,
                    "name": item.name,
                    "title": item.title,
                    "placement": item.placement,
                    "address": item.address,
                    "approved": item.isApproved,
                    "owner": item.owner_id,
                    "hours": hours
                  }
                };
                featurecollection.features.push(geojson);
              }
            }
          } catch (e) {
            console.log("Something wrong with: " + file);
          }
        }
        count = count - 1;
        //console.log("Countdown: " + count);
        if (count === 0){
          stream.write(JSON.stringify(featurecollection));
          stream.end();
        }
      });
    });
 });
