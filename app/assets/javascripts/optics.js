function Document() {
  this.id = null;
  this.dimensions = {};
  this.processed = false;
  this.reachabilityDistance = undefined;
}

function Queue() {
  var _queue = [];

  this.remove = function(elem) {
    var length = _queue.length;

    for(var index = 0; index < length; index++) {
      var otherElem = _queue[index];

      if( elem.id === otherElem.id ) {
        var firstQueuePart = _queue.slice(0, index);
        var secondQueuePart = _queue.slice(index + 1, _queue.length);

        _queue = firstQueuePart.concat(secondQueuePart);
        break;
      }
    }

    return this;
  };

  this.insert = function(elem) {
    var indexToInsert = _queue.length;
    for(var index = _queue.length - 1; index >= 0; index--) {
      if( elem.reachabilityDistance < _queue[index].reachabilityDistance ) {
        indexToInsert = index;
      }
    }
    insertAt(elem, indexToInsert);
  };

  this.forEach = function(func) {
    _queue.forEach(func);
  };

  this.getElements = function() { return _queue; };

  var insertAt = function(elem, index) {
    if(_queue.length === index) {
      _queue.push(elem);
      return;
    }
    else {
      var currentElement = _queue[index];

      if( _queue[index] === undefined )
        return false;

      _queue[index] = elem;

      var length = _queue.length + 1;
      for(var pos = index + 1; pos < length; pos++) {
        var lastElement = _queue[pos];
        _queue[pos] = currentElement;
        currentElement = lastElement;
      }
    }
  };
}

function OPTICS(dataset) {
  var unsortedList = null;
  var sortedList = null;
  var priorityQueue = null;
  var coreDistance = 0;
  var that = null;

  this.start = function(epsilon, minPts){
    unsortedList = [];
    sortedList = [];

    init.call(this, dataset);

    unsortedList.forEach(function(doc, key){
      if( !doc.processed ) {
        var neighbours = getNeighbours(doc, epsilon);
        doc.processed = true;
        sortedList.push(doc);

        priorityQueue = new Queue();

        if( calculateCoreDistance(doc, epsilon, minPts) !== undefined ) {
          updateQueue(neighbours, doc, priorityQueue, epsilon, minPts);

          var call = function(){
            for(var d = 0; d < priorityQueue.getElements().length; d++) {
              var queued_document = priorityQueue.getElements()[d];

              if( !queued_document.processed ) {
                var neighbours = getNeighbours(queued_document, epsilon);
                queued_document.processed = true;
                sortedList.push(queued_document);

                if( calculateCoreDistance(queued_document, epsilon, minPts) !== undefined ) {
                  updateQueue(neighbours, queued_document, priorityQueue, epsilon, minPts);
                  call();
                }
              }
            }
          };
          call();
        }
      }
    });
    return sortedList;
  };

  this.drawBarChartPlot = function(dataset, epsilon, minPts, width, height){
    
    var output = document.createElement('canvas');
    
    output.height = height;
    output.width = width;
    
    var ctx = output.getContext ('2d');

    ctx.fillStyle = '#FF0000';
    //ctx.fillRect ( 0 , 0 , output.width, output.height );
    ctx.fill();

    ctx.beginPath ();
    ctx.fillStyle = '#0000ff';
    ctx.strokeStyle = '#ffff00';
    
    ctx.font = '15pt Arial';
    ctx.lineWidth = 8;
    
    ctx.save();
    ctx.translate(90, 20);
    ctx.rotate( (Math.PI/180)*90 );
    ctx.fillText( ('Epsilon: ' + epsilon), 10,25 );
    ctx.fillText( ('MinPts: ' + minPts), 10,50 );
    ctx.restore();
    
    ctx.font = '6pt Arial';
    
    var xStartPoint = 120,
        yStartPoint = Number(output.height) - 80;
    
    dataset.forEach(function(doc, key){
      
      ctx.beginPath ();
      ctx.moveTo(xStartPoint, yStartPoint);
      ctx.strokeStyle = '#CCCCCC';
      
      console.log(doc.reachabilityDistance);
      if(doc.reachabilityDistance)
        ctx.lineTo(xStartPoint, (yStartPoint - (doc.reachabilityDistance * (output.height))) );
      else
        ctx.lineTo(xStartPoint, 0);
      
      ctx.save();
      ctx.translate(xStartPoint, (Number(output.height) - 5));
      ctx.rotate( (Math.PI/180)*-90 );
      ctx.fillText( doc.id.toString(), 0, 3 );
      ctx.restore();
      
      ctx.stroke();
      ctx.closePath();
      
      xStartPoint += 10;
      
    });
    
    ctx.fill();
    ctx.stroke();
    ctx.closePath();
    
    drawAxes(ctx, 115, yStartPoint, Number(output.width), Number(output.height), dataset.length, 100);
    
    var visual = convertToImg(output);
    
    return visual;
  };

  this.distance = function(doc1, doc2) {
    return (1 - document_matrix[doc1.id][doc2.id]);
  };

  var getNeighbours = function (doc, epsilon) {
    var neighbours = [];
    unsortedList.forEach(function(otherDoc, key){
      if( doc !== otherDoc && 0 < that.distance(doc, otherDoc) && that.distance(doc, otherDoc) <= epsilon ) {
        neighbours.push(otherDoc);
      }
    });
    return neighbours; 
  };

   var calculateCoreDistance = function(doc, epsilon, minPts) {
    var neighbours = getNeighbours(doc, epsilon);
    var minDistance = undefined;

    if( neighbours.length >= minPts ) {
      var minDistance = epsilon;

      neighbours.forEach(function(otherDoc, key){
        if( that.distance(doc, otherDoc) < minDistance ) {
          minDistance = that.distance(doc, otherDoc);
        }
      });
    }
    return minDistance;
  };

  var updateQueue = function(neighbours, doc, queue, epsilon, minPts) {
    coreDistance = calculateCoreDistance(doc, epsilon, minPts);

    neighbours.forEach(function(otherDoc, key){
      if( !otherDoc.processed ) {
        var newReachableDistance = Math.max(coreDistance, that.distance(doc, otherDoc));

        if(otherDoc.reachabilityDistance === undefined) {
          otherDoc.reachabilityDistance = newReachableDistance;
          queue.insert(otherDoc);
        }
        else if( newReachableDistance < otherDoc.reachabilityDistance ) {
          otherDoc.reachabilityDistance = newReachableDistance;
          queue.remove({ id: otherDoc.id });
          queue.insert(otherDoc);
        }
      }
    });
  };

  var drawAxes = function(ctx, start_x, start_y, x_axis_width, y_axis_height, x_units, y_units){
    
    ctx.beginPath();
    ctx.lineWidth = 3;
    ctx.fillStyle = '#000000';
    ctx.strokeStyle = '#000000';
    
    ctx.moveTo(start_x, start_y);
    ctx.lineTo( start_x + x_axis_width, start_y);
    
    var nextPosX = start_x;
    
    for(var u=0; u < x_units; u++){
      
      ctx.moveTo(nextPosX, start_y + 5);
      ctx.lineTo(nextPosX, start_y - 5 );
      ctx.fillText( u.toString(), nextPosX-3, (start_y + 10));
      
      nextPosX = start_x + (10 * (u + 1));
    }
    
    ctx.moveTo(start_x, start_y);
    ctx.lineTo(start_x, 0);
    
    ctx.fill();
    ctx.stroke();
    ctx.closePath();
    
  };
  
  var convertToImg = function(canvas){
    var img = document.createElement('img');
    img.width = canvas.width;
    img.height = canvas.height;
    img.src = canvas.toDataURL();
    return img;
  };

  var init = function(dataset) {

    that = this;

    for(var i = 0; i < dataset.length; i++) {
      var doc = new Document();
      doc.id = i;
      
      for(var j = 0; j < Object.keys(dataset[i]).length; j++) {
        doc.dimensions[j] = dataset[i][j];
      }
      unsortedList.push(doc);
    }
  };
}
