let mysql  = require('mysql');

const client = mysql.createConnection({
    user: 'cs540_group17',
    host: 'classmysql.engr.oregonstate.edu',
    database: 'cs540_group17',
    password: 'UhpTQRAe2ryr',
    port: 3306
  });

 
client.connect();


module.exports = client;
 