var AWS = require('aws-sdk');

AWS.config.update({region: 'us-east-1'});

var db = new AWS.DynamoDB({apiVersion: '2012-10-08'});

var params = {
  AttributeDefinitions: [
    {
      AttributeName: 'ARTICLE_ID',
      AttributeType: 'N'
    },
    {
      AttributeName: 'ARTICLE_DATE',
      AttributeType: 'S'
    }
  ],
  KeySchema: [
    {
      AttributeName: 'ARTICLE_ID',
      KeyType: 'HASH'
    },
    {
      AttributeName: 'ARTICLE_DATE',
      KeyType: 'RANGE'
    }
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits: 1,
    WriteCapacityUnits: 1
  },
  TableName: 'IFNDEF_ARTICLES',
  StreamSpecification: {
    StreamEnabled: false
  }
};

exports.handler = function(event, context, callback) {
    
  db.createTable(params, function(err, data) {
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
