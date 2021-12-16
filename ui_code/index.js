const express = require('express');
const app = express();
const port = 3000;

app.use(express.static('public'));
app.use(express.static('public/image'));
// Views
app.set('views', './views');
app.set('view engine', 'pug');

const sql = require('mssql');

// config for your database
const config = {
  user: 'phuoctran',
  password: '123456789',
  server: 'localhost',
  database: 'HOAYEUTHUONG',
  trustServerCertificate: true,
};

// connect to your database
sql.connect(config, function(err) {
  if (err) console.log(err);

  // create Request object
  const request = new sql.Request();

  // query to the database and get the records
  request.query('select * from SANPHAM', function(err, recordset) {
    if (err) console.log(err);

    // send records as a response
    console.log(recordset);
  });
});

app.get('/', (req, res) => {
  res.render('index');
});

app.get('/cart', (req, res) => {
  res.render('cart');
});


app.get('/admin', (req, res) => {
  res.render('admin');
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
