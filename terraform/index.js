var AWS = require('aws-sdk');

AWS.config.update({region: 'us-east-1'});

exports.handler = function(event, context, callback) {
  var db = new AWS.DynamoDB.DocumentClient();

  var params = {
    TableName: "IFNDEF_ARTICLES"
  }
    
  db.scan(params, function(err, data) {
    if (err) return callback(null, { statusCode: '500', body: err });
    
    callback(null, {
      statusCode: '200',
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });     
};

exports.icrement_views = function(event, context, callback) {
  var db = new AWS.DynamoDB();
  var incrementParams = {
  TableName: "IFNDEF_ARTICLES",
  Key: {
    "ArticleId": { 
      "N": event.ArticleId.toString()
    },
    "ArticleDate": {
      "S": event.ArticleDate
    }
  },
  UpdateExpression: "set Replies = Replies + :num",
  ExpressionAttributeValues: { ":num": { "N": "1"} },
  ReturnValues: "ALL_NEW"
}

  db.updateItem(incrementParams, function(err, data) {
    if (err) return callback(null, { statusCode: '500', body: err });
    
    callback(null, {
      statusCode: '200',
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });
}