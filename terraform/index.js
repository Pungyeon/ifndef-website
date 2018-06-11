var AWS = require('aws-sdk');

AWS.config.update({region: 'us-east-1'});

var db = new AWS.DynamoDB.DocumentClient();

var params = {
  TableName: "IFNDEF_ARTICLES"
}

exports.handler = function(event, context, callback) {
    
  db.scan(params, function(err, data) {
    if (err) callback(null, { statusCode: '500', body: err });
    
    callback(null, {
      statusCode: '200',
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });     
};

var incrementParams = {
  TableName: "IFNDEF_ARTICLES",
  Key: {
    "ArticleId": { 
      "N": event.ArticleId
    },
    "ArticleDate": {
      "S": event.ArticleDate
    }
  },
  UpdateExpression: "set Replies = Replies + :num",
  ExpressionAttributeValues: { ":num": { "N": "1"} },
  ReturnValues: "ALL_NEW"
}

exports.icrement_views = function(event, context, callback) {
  db.UpdateItem(params, function(err, data) {
    if (err) callback(null, { statusCode: '500', body: err });
    
    callback(null, {
      statusCode: '200',
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });
}