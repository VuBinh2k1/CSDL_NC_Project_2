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

let MaHD_Local = 0;

// config for your database
const config = {
  user: 'gruviamon',
  password: '123',
  server: 'localhost',
  database: 'HOAYEUTHUONG',
  trustServerCertificate: true,
};

// connect to your database
sql.connect(config, function(err) {
  if (err) console.log(err);
});

app.get('/', (req, res) => {
  const request = new sql.Request();
  let query = "TIMEKIEMSP_CHUDE N'Bó hoa tươi'";
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
});

app.get('/deleteItem', (req, res) => {
  const request = new sql.Request();
  let query = "DELETE CT_HOADON WHERE MaSP =" + req.query.MaSP+ " AND MaHD =" + MaHD_Local;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    // send records as a response
    res.redirect('/cart');
  });
})

app.post('/thanhtoan', (req, res) => {
  const request = new sql.Request();
  let query;
  if(req.body.guitang === 'true') {
    query = "THANHTOAN '" + MaHD_Local + "', N'" + req.body.HINHTHUCTT + "'," + "N'" + req.body.HOTENNGUOINHAN + "'" + ",'" + req.body.SDTNGNHAN + "'," + "N'" + req.body.DIACHI + "'"  + "," + "'" + req.body.EMAIL + "'" + ',' + "'" + req.body.THOIGIANGIAO + "'" + ',' + "N'" + req.body.LOINHAN + "'";
  } else {
    query = "THANHTOAN '" + MaHD_Local + "', N'" + req.body.HINHTHUCTT + "'," + "''" + ',' + "''" + ',' + "''" + ',' +  "''" + ',' + "'" + req.body.THOIGIANGIAO + "'" + ',' + "N'" + req.body.LOINHAN + "'";
  }
  // console.log(query);
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    // send records as a response
    MaHD_Local = 0;
    res.redirect('/');
  });
})

app.post('/addVoucher', (req, res) => {
  const request = new sql.Request();
  let query = "APDUNGVOUCHER " + MaHD_Local + ',' + "'" + req.body.voucher + "'";
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    // send records as a response
    res.redirect('/cart');
  });
});

app.get('/cart', (req, res) => {
  const request = new sql.Request();
  let query = "SELECT CT.MaSP, SP.TenSP, CT.SoLuong, CT.ThanhTien CT, HD.TongTien FROM SANPHAM SP, CT_HOADON CT, HOADON HD WHERE SP.MASP = CT.MaSP AND HD.MaHD = CT.MaHD AND CT.MaHD =" + MaHD_Local;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    let data = [];
    let datasize = recordset.recordset.length > 50 ? 52 : recordset.recordset.length;
    for(let i = 0; i < datasize; i++) {
      data.push(recordset.recordset[i]);
    }
    if(data.length !== 0) {
      res.locals.data = data;
    }
    // send records as a response
    res.render('cart');
  });
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
      res.locals.chamcong = recordset.recordset;
      // send records as a response
      res.render('staff');
    }
  });
});

app.post('/taovoucher', (req, res) => {
  const request = new sql.Request();
  let query = "THEMVOUCHER_GIAMGIA " + req.body.MAVC + ',' + req.body.GTRI + ',' + "'" + req.body.HSD + "'" + ',' + req.body.SL;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    res.locals.mess = true;
    res.render('manager');
  });
});

app.get('/loadData', (req, res) => {
  const request = new sql.Request();
  let query = "THONGKEBANCHAY";
  request.query(query, function(err, recordset) {
    localVars = 1;
    if (err) console.log(err);
    if (recordset == undefined) {
      res.locals.errorData = true;
      res.render('manager');
    } else {
      let data = [];
      let datasize = recordset.recordset.length > 50 ? 52 : recordset.recordset.length;
      for(let i = 0; i < datasize; i++) {
        data.push(recordset.recordset[i]);
      }
      res.locals.data = data;
      // send records as a response
      res.render('manager');
    }
  });
});

app.get('/loadData2', (req, res) => {
  const request = new sql.Request();
  let query = "THONGKEBANCHAM";
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    if (recordset == undefined) {
      res.locals.errorData = true;
      res.render('manager');
    } else {
      let data = [];
      let datasize = recordset.recordset.length > 50 ? 52 : recordset.recordset.length;
      for(let i = 0; i < datasize; i++) {
        data.push(recordset.recordset[i]);
      }
      res.locals.data2 = data;
      // send records as a response
      res.render('manager');
    }
  });
});

app.get('/loadData3', (req, res) => {
  console.log(localVars);
  const request = new sql.Request();
  let query = "THONGKEDOANHTHU";
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    if (recordset == undefined) {
      res.locals.errorData = true;
      res.render('manager');
    } else {
      let data = [];
      let datasize = recordset.recordset.length > 50 ? 52 : recordset.recordset.length;
      for(let i = 0; i < datasize; i++) {
        data.push(recordset.recordset[i]);
      }
      res.locals.data3 = data;
      // send records as a response
      res.render('manager');
    }
  });
});

app.post('/themsanpham', (req, res) => {
  const request = new sql.Request();
  let query = "THEMSP " + req.body.LOAI + ',' + "'" + req.body.TENSP + "'" + ',' + "'" + req.body.NGAYST + "'" + ',' + req.body.GIASP + ',' + req.body.GIAMGIA + ',' + req.body.TTINSP + ',' + "'" + req.body.TTSP + "'";
  if(req.body.ChuDe !== "") {
    query = query + ',' + req.body.ChuDe;
  }
  if(req.body.ChuDe_2 !== "") {
    query = query + ',' + req.body.ChuDe_2;
  }
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    res.locals.mess = true;
    res.render('admin');
  });
});

app.post('/themchude', (req, res) => {
  const request = new sql.Request();
  let query = "THEM_CHUDE " + req.body.MASP + ',' + req.body.ChuDe;
  if(req.body.ChuDe_2 !== "") {
    query = query + ',' + req.body.ChuDe_2;
  }
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    res.locals.mess = true;
    res.render('admin');
  });
});

app.post('/hethang', (req, res) => {
  const request = new sql.Request();
  let query = "XOA_SP " + req.body.MASP;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    res.locals.mess = true;
    res.render('admin');
  });
});

app.post('/addToCart', (req, res) => {
  const request = new sql.Request();
  let query = "THEMVAOGIOHANG " + '6' + ',' + MaHD_Local + ',' + req.body.MaSP + ',' + req.body.SL;
  request.query(query, function(err, recordset) {
    if (err) console.log(err);
    MaHD_Local = recordset.recordset[0].MaHD;

    res.redirect('/cart');
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