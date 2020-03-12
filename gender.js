const db = require('./connection');

let get_wages = async () => {
    try {
        db.query('select * from gender ', function (error, results, fields) {
            if (error) throw error;
            for(let i=0;i<results.length;i++){
                let male_percent = results[i]['male']/results[i].total*100;
                let female_percent = results[i]['female']/results[i].total*100;
                db.query(`update gender set male_percent=${male_percent}, female_percent=${female_percent}
                            where location = '${results[i].location}'`, function(error, results, fields){
                                if (error) throw error;
                            });
            }
          });

    } catch (err) {
        if (!err.statusCode) {
            err.statusCode = 500;
        }
        console.log('problem with query');
    }
}

get_wages();