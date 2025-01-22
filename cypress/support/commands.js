const JDBC = require('nodejs-jdbc');

Cypress.Commands.add('queryDatabase', (query) => {
  return new Promise((resolve, reject) => {
    const config = {
      // Update these with your database details
      url: 'jdbc:postgresql://localhost:5432/your_database',
      drivername: 'org.postgresql.Driver',
      minpoolsize: 1,
      maxpoolsize: 10,
      properties: {
        user: 'your_username',
        password: 'your_password'
      }
    };

    const pool = new JDBC(config);

    pool.reserve((err, connObj) => {
      if (err) {
        reject(err);
        return;
      }

      const conn = connObj.conn;
      
      conn.createStatement((err, statement) => {
        if (err) {
          pool.release(connObj, err => {});
          reject(err);
          return;
        }

        statement.executeQuery(query, (err, resultset) => {
          if (err) {
            pool.release(connObj, err => {});
            reject(err);
            return;
          }

          resultset.toObjArray((err, results) => {
            pool.release(connObj, err => {});
            if (err) {
              reject(err);
              return;
            }
            resolve(results);
          });
        });
      });
    });
  });
});
