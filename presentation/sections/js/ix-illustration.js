
var app = angular.module('presentation',[]);

app.controller( "InvertedIndexController", function ($scope, $filter, $sce) {

    var orderBy = $filter('orderBy');

    $scope.documents = {
        "1": 'work it make it do it makes us harder better faster stronger',
        "2":'more than hour hour never ever after work is over',
        "3":'work it harder make it better do it faster makes us stronger'
    };

    $scope.documentsHtml = {
        "1": $sce.trustAsHtml($scope.documents['1']),
        "2": $sce.trustAsHtml($scope.documents['2']),
        "3": $sce.trustAsHtml($scope.documents['3'])
    };

    //$sce.trustAsHtml(
    $scope.invIndex = [];


    $scope.highlight = function(word) {
        console.log('highlight ' + word);
    };

    $scope.buildInvIndex = function() {

        console.log('buildInvIndex');
        var itemsMap = {};
        for(var docIx in $scope.documents) {
            var doc = $scope.documents[docIx];
            doc = doc.trim();
            console.log(doc);
            var words = doc.split(' ');

            for(var wordIx = 0; wordIx < words.length; wordIx++) {
                var word = words[wordIx];

                if(itemsMap[word] === undefined || itemsMap[word] === null) {
                    itemsMap[word] = {
                        'word': word
                    };
                }

                if(itemsMap[word]['documents'] === undefined || itemsMap[word]['documents'] === null) {
                    itemsMap[word]['documents'] = {};
                }

                if(itemsMap[word]['documents'][docIx] === undefined || itemsMap[word]['documents'][docIx] === null) {
                    itemsMap[word]['documents'][docIx] = [];
                }

                itemsMap[word]['documentsLength'] = Object.keys(itemsMap[word].documents).length;
                itemsMap[word]['documents'][docIx].push(wordIx);
            }
        }

        $scope.invIndex = [];
        for(var wordKey in itemsMap) {
            $scope.invIndex.push(itemsMap[wordKey]);
        }

        $scope.invIndex = orderBy($scope.invIndex, 'word', false);


    };


});

var svg = null;

function init(e) {

    angular.bootstrap(document, ['presentation']);
    
    console.log("You are on a slide that will one day have an illustration");
}

function onShow(e) {
    init(e);  
}

document.addEventListener( 'ix-illustration-show', onShow, false );