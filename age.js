const db = require('./connection');

let get_wages = async () => {
    try {
        db.query('select * from age ', function (error, results, fields) {
            if (error) throw error;
            for(let i=0;i<results.length;i++){
                let percent_18 = results[i]['0_18']/results[i].total*100;
                let percent_25 = results[i]['19_25']/results[i].total*100;
                let percent_34 = results[i]['26_34']/results[i].total*100;
                let percent_54= results[i]['35_54']/results[i].total*100;
                let percent_64= results[i]['55_64']/results[i].total*100;
                let percent_65plus= results[i]['65plus']/results[i].total*100;
                db.query(`update age set 0_18_percent=${percent_18}, 19_25_percent=${percent_25},26_34_percent=${percent_34},
                35_54_percent=${percent_54}, 55_64_percent=${percent_64}, 65plus_percent=${percent_65plus}
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