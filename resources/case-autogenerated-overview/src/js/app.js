(function () {
    'use strict';

    /**
     * Polyfill for IE
     */
    if (!window.console) {
        window.console = {
            log: angular.noop,
            error: angular.noop,
            debug: angular.noop,
            warn: angular.noop
        };
    }

    if (!window.console.debug) {
        window.console.debug = window.console.log;
    }

    // Detect if the browser is IE... (we cannot detect IE10/11 with Paul Irish hack)
    if (window.navigator.userAgent.indexOf('IE') > -1) {
        document.body.className += ' isBrowser-ie'; // IE9 does not have classList API
    }


    var app = angular.module('caseOverview', [
        'ui.bootstrap',
        'ngResource',
        'gettext',
        'org.bonita.common.resources',
        'angular-timeline',
        'org.bonitasoft.services.i18n',
        'org.bonitasoft.common.filters.stringTemplater'
    ]);

    app.controller('MainCtrl', ['$scope', '$window', 'archivedTaskAPI', '$location', 'overviewSrvc', 'urlParser', 'i18nService', '$http', function ($scope, $window, archivedTaskAPI, $location, overviewSrvc, urlParser, i18nService, $http) {

        $scope.case = {};
        $scope.i18nLoaded = false;

        $scope.isInternalField = function (propertyName) {
            return (propertyName === 'persistenceId') || (propertyName === 'persistenceVersion') || (propertyName === 'links');
        };


        var caseId = urlParser.getQueryStringParamValue('id');

        $http({ method: 'GET', url: '../API/system/session/unusedId' })
            .success(function (data, status, headers) {
                $http.defaults.headers.common['X-Bonita-API-Token'] = headers('X-Bonita-API-Token');
                init();
            }
        );

        var init = function () {
            i18nService.then(function () {
                $scope.i18nLoaded = true;
            });

            overviewSrvc.fetchCase(caseId).then(function (result) {
                $scope.case = result;

                // Tasks can only be listed based on sourceObjectId in case of archived case
                // So I need to make a conversion of the ID to use.
                $scope.case.caseIdToDisplay = $scope.case.sourceObjectId || $scope.case.id;

                overviewSrvc.listDoneTasks($scope.case.caseIdToDisplay).then(function mapArchivedTasks(data) {
                    $scope.doneTasks = data;
                });
            });

            overviewSrvc.fetchContext(caseId).then(function (data) {
                $scope.businessData = data.businessData;
                $scope.documents = data.documents;
            });
        };
    }]);


})();
