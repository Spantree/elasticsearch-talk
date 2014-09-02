
var app = angular.module('presentation',[]);

app.controller( "InvertedIndexController", function ($scope, $filter, $sce, $timeout) {

    var orderBy = $filter('orderBy');

    $scope.documents = {
        "1":'work it harder make it better',
        "2":'do it faster makes us stronger',
        "3":'more than ever hour after',
    };

    $scope.documentCount = null;

    $scope.documentsHtml = {};
    $scope.invIndexMap = {}
    $scope.invIndex = [];
    $scope.searchQuery = '';
    $scope.searchWords = [];
    $scope.termFrequencies = {};
    $scope.documentFrequencies = {};

    $scope.resetHighlighting = function() {
        for(docKey in $scope.documents) {
            $scope.documentsHtml[docKey] = $sce.trustAsHtml($scope.documents[docKey]); 
        }
    }

    $scope.resetHighlighting();

    $scope.updateQuery = function() {
        if( Object.keys($scope.invIndexMap).length === 0) {
            $scope.buildInvIndex();
            $scope.documentCount = Object.keys($scope.documents).length;
        }

        $scope.searchWords = $scope.searchQuery.trim().split(' ');

        $scope.documentFrequencies = {};
        $scope.termFrequencies = {}

        for(wordIx in $scope.searchWords) {
            var word = $scope.searchWords[wordIx];

            if($scope.invIndexMap[word] !== undefined) {
                $scope.documentFrequencies[word] = Object.keys($scope.invIndexMap[word]['documents']).length;

                for(docKey in $scope.documents) {

                    if($scope.termFrequencies[docKey] == undefined) {
                        $scope.termFrequencies[docKey] = {};
                    }

                    if($scope.invIndexMap[word]['documents'][docKey] !== undefined) {
                        $scope.termFrequencies[docKey][word] = Object.keys($scope.invIndexMap[word]['documents'][docKey]).length;
                    } else {
                        $scope.termFrequencies[docKey][word] = 0;
                    }
                }
            } else {
                $scope.documentFrequencies[word] = 0;

                for(docKey in $scope.documents) {
                    if($scope.termFrequencies[docKey] == undefined) {
                        $scope.termFrequencies[docKey] = {};
                    }

                    $scope.termFrequencies[docKey][word] = 0;
                }
            }

            
        }

    };

    $scope.updateMathJax = function() {
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
    }

    $scope.highlight = function(word) {
        $scope.resetHighlighting();
        
        var wordLocations = $scope.invIndexMap[word];

        for(docKey in wordLocations.documents) {
           var doc = $scope.documents[docKey].trim().split(' ');
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

// Copied from http://stackoverflow.com/a/16646667 and then slightly modified
app.directive("mathjaxBind", function() {
    return {
        restrict: "A",
        controller: ["$scope", "$element", "$attrs",
            function($scope, $element, $attrs) {
                $scope.$watch(
                    function() {
                        return $element.attr( $attrs.$attr.mathjaxBind); 
                    }, 
                    function(texExpression) {
                        var texScript = angular.element("<script type='math/tex'>")
                            .html(texExpression ? texExpression :  "");
                        $element.html("");
                        $element.append(texScript);
                        MathJax.Hub.Queue(["Reprocess", MathJax.Hub, $element[0]]);
                    }
                );
        }]
    };
});

var svg = null;

function init(e) {
    angular.bootstrap(document, ['presentation']);
}

function onShow(e) {
    init(e);  
}

document.addEventListener( 'ix-illustration-show', onShow, false );
document.addEventListener( 'tfidf-illustration-show', onShow, false );
