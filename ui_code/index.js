const express = require('express');
const app = express();
const port = 3000;

app.use(express.static('public'));
app.use(express.static('public/image'));
// Views
app.set('views', './views');
app.set('view engine', 'pug');

const sql = require('mssql');

app.use(express.json());
app.use(express.urlencoded({extended: true}));

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
});

app.get('/', (req, res) => {
  res.render('index');
});

app.get('/cart', (req, res) => {
  res.render('cart');
});

app.post('/', function(req, res) {
  const request = new sql.Request();
  let query = "TIMKIEMSP " + req.body.search;
  // query to the database and get the record
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    if (recordset.recordset == undefined) {
      res.locals.error = true;
      res.render('index');
    } else {
      // send records as a response
      res.locals.data = [recordset.recordset[0]];
      res.render('index');
    }
  });
});

app.get('/chude', (req, res) => {
  const request = new sql.Request();
  let query = "TIMEKIEMSP_CHUDE N'" + req.query.query.split("_").join(" ") + "'";
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    let data = [];
    let datasize = recordset.recordset.length > 50 ? 52 : recordset.recordset.length;
    for(let i = 0; i < datasize; i++) {
      data.push(recordset.recordset[i]);
    }
    res.locals.data = data;
    // send records as a response
    res.render('index');
  });
})

app.post('/timhoadon', (req, res) => {
  const request = new sql.Request();
  let query = "KTRA_HD " + req.body.search;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    if (recordset == undefined) {
      res.locals.errorDonHang = true;
      res.render('staff');
    } else {
      res.locals.data = recordset.recordset[0];
      // send records as a response
      res.render('staff');
    }
  });
});

app.post('/chamcong', (req, res) => {
  const request = new sql.Request();
  let query = "XEM_BCCONG " + req.body.search;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    if (recordset.recordset == undefined) {
      res.locals.errorChamCong = true;
      res.render('staff');
    } else {
      res.locals.chamcong = recordset.recordset[0];
      // send records as a response
      res.render('staff');
    }
  });
});

app.get('/admin', (req, res) => {
  res.render('admin');
});

app.get('/manager', (req, res) => {
  res.render('manager');
});

app.get('/staff', (req, res) => {
  res.render('staff');
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});