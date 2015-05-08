
var app = angular.module('presentation',[]);

app.controller( "InvertedIndexController", function ($scope, $filter, $sce, $timeout) {

    var orderBy = $filter('orderBy');
    var number = $filter('number');

    $scope.documents = {
        "0":'work it harder make it better',
        "1":'do it faster makes us stronger',
        "2":'more than ever hour after',
    };

    $scope.documentCount = null;

    $scope.documentsHtml = {};
    $scope.invIndexMap = {}
    $scope.invIndex = [];
    $scope.searchQuery = '';
    $scope.searchWords = [];
    $scope.termFrequencies = {};
    $scope.documentFrequencies = {};
    $scope.tfidfScores = {};
    $scope.showTfidfFormulas = true;
    $scope.tab = 'tfidf';

    $scope.resetHighlighting = function() {
        for(docKey in $scope.documents) {
            $scope.documentsHtml[docKey] = $sce.trustAsHtml($scope.documents[docKey]); 
        }
    }

    $scope.resetHighlighting();

    $scope.getCosSimFormula = function(docKey) {
        var dotProductTerms = [];
        var docLenTerms = [];
        var queryLenTerms = [];

        var wordScores = $scope.tfidfScores[docKey]

        for(wordIx in $scope.searchWords) {
            var wordKey = $scope.searchWords[wordIx];
            var score = wordScores[wordKey];
            
            dotProductTerms.push(number(score, 2) + '\\times 1');
            docLenTerms.push(number(score, 2) + '^2');
            queryLenTerms.push('1^2');
        }
        return '\\frac{ ' + dotProductTerms.join(' + ') +' }{ \\sqrt{' + docLenTerms.join(' + ') + '} \\sqrt{' + queryLenTerms.join(' + ') + '} }';
    };

    $scope.getCosSimValue = function(docKey) {
        var dotProductValue = 0;
        var docLen = 0;
        var queryLen = 0;

        var wordScores = $scope.tfidfScores[docKey]

        for(wordIx in $scope.searchWords) {
            var wordKey = $scope.searchWords[wordIx];
            var score = wordScores[wordKey];

            dotProductValue += score;
            docLen += ( score * score );
            queryLen++;  
        } 

        var cosSimScore =  dotProductValue

        if(docLen > 0) {
            cosSimScore = cosSimScore / ( Math.sqrt(docLen) * Math.sqrt(queryLen) );
            return cosSimScore; 
        } else {
            return 0;
        }
        
    }

    $scope.updateQuery = function() {
        if( Object.keys($scope.invIndexMap).length === 0) {
            $scope.buildInvIndex();
            $scope.documentCount = Object.keys($scope.documents).length;
        }

        console.log($scope.searchQuery);
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

        
        for(docKey in $scope.documents) {
            $scope.tfidfScores[docKey] = {};

            for(wordIx in $scope.searchWords) {
                var word = $scope.searchWords[wordIx];

                if($scope.documentFrequencies[word] === 0) {
                    $scope.tfidfScores[docKey][word] = 0;
                } else {
                    $scope.tfidfScores[docKey][word] = $scope.termFrequencies[docKey][word] * ( Math.log( $scope.documentCount / $scope.documentFrequencies[word] ) / Math.LN10 );
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
