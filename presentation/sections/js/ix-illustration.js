
var app = angular.module('presentation',[]);

app.controller( "InvertedIndexController", function ($scope, $filter, $sce) {

    var orderBy = $filter('orderBy');

    $scope.documents = {
        "1":'work it harder make it better',
        "2":'do it faster makes us stronger',
        "3":'more than ever hour after',
    };

    $scope.documentsHtml = {};
    $scope.invIndexMap = {}
    $scope.invIndex = [];

    $scope.resetHighlighting = function() {
        for(docKey in $scope.documents) {
            $scope.documentsHtml[docKey] = $sce.trustAsHtml($scope.documents[docKey]); 
        }
    }

    $scope.resetHighlighting();

    $scope.highlight = function(word) {
        $scope.resetHighlighting();
        console.log('highlight ' + word);
        var wordLocations = $scope.invIndexMap[word];
        for(docKey in wordLocations.documents) {
           var doc = $scope.documents[docKey].trim();
           var words = doc.split(' ');
           var wordIndices = wordLocations['documents'][docKey]

           for(ix in wordIndices) {
            var wordIx = wordIndices[ix];
            words[wordIx] = "<em class=\"text-primary\">" + words[wordIx] + "</em>" 
           }
           
           var newDoc = words.join(' ');

           $scope.documentsHtml[docKey] = $sce.trustAsHtml(newDoc); 
        }
    };

    $scope.buildInvIndex = function() {

        $scope.invIndexMap = {};
        for(var docIx in $scope.documents) {
            var doc = $scope.documents[docIx];
            doc = doc.trim();
            var words = doc.split(' ');

            for(var wordIx = 0; wordIx < words.length; wordIx++) {
                var word = words[wordIx];

                if($scope.invIndexMap[word] === undefined || $scope.invIndexMap[word] === null) {
                    $scope.invIndexMap[word] = {
                        'word': word
                    };
                }

                if($scope.invIndexMap[word]['documents'] === undefined || $scope.invIndexMap[word]['documents'] === null) {
                    $scope.invIndexMap[word]['documents'] = {};
                }

                if($scope.invIndexMap[word]['documents'][docIx] === undefined || $scope.invIndexMap[word]['documents'][docIx] === null) {
                    $scope.invIndexMap[word]['documents'][docIx] = [];
                }

                $scope.invIndexMap[word]['documentsLength'] = Object.keys($scope.invIndexMap[word].documents).length;
                $scope.invIndexMap[word]['documents'][docIx].push(wordIx);
            }
        }

        $scope.invIndex = [];
        for(var wordKey in $scope.invIndexMap) {
            $scope.invIndex.push($scope.invIndexMap[wordKey]);
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