const db = require('./connection');

let get_wages = async () => {
    try {
        db.query('select * from ethinicity ', function (error, results, fields) {
            if (error) throw error;
            for(let i=0;i<results.length;i++){
                let percent_white = results[i].white/results[i].total*100;
                let percent_black = results[i].black/results[i].total*100;
                let percent_hispanic = results[i].hispanic/results[i].total*100;
                let percent_na= results[i].native_american/results[i].total*100;
                let percent_asian= results[i].asian/results[i].total*100;
                let percent_multiple= results[i].multiple/results[i].total*100;
                db.query(`update ethinicity set white_percent=${percent_white}, black_percent=${percent_black},hispanic_percent=${percent_hispanic},
                            na_percent=${percent_na}, asian_percent=${percent_asian}, multiple_percent=${percent_multiple}
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