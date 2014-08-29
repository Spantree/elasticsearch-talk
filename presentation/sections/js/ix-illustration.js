angular.module('presentation',[]).controller( "InvertedIndexController", function ($scope, $filter) {

    var orderBy = $filter('orderBy');

    $scope.documents = [
        'document one is cool',
        'document two is cool',
        'document three is kinda cool'
    ]

    $scope.invIndex = []

    $scope.buildInvIndex = function() {
        var itemsMap = {}
        for(var docIx in $scope.documents) {
            var doc = $scope.documents[docIx];
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

                if(itemsMap[word][docIx] === undefined || itemsMap[word][docIx] === null) {
                    itemsMap[word]['documents'][docIx] = [];
                }

                itemsMap[word]['documents'][docIx].push(wordIx);
            }
        }

        $scope.invIndex = [];
        for(var wordKey in itemsMap) {
            $scope.invIndex.push(itemsMap[wordKey]);
        }

        $scope.invIndex = orderBy($scope.invIndex, 'word', false);
        console.log($scope.invIndex);
    };

    $scope.buildInvIndex();
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