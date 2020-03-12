const db = require('./connection');

let get_wages = async () => {
    try {
        db.query('select * from citizenship ', function (error, results, fields) {
            if (error) throw error;
            for(let i=0;i<results.length;i++){
                let citizen_percent = results[i]['citizen']/results[i].total*100;
                let non_citizen_percent = results[i]['non_citizen']/results[i].total*100;
                db.query(`update citizenship set citizen_percent=${citizen_percent}, non_citizen_percent=${non_citizen_percent}
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