angular.module('bonitasoft.ui').config(function($locationProvider){
  if (history.pushState) {
    $locationProvider.html5Mode({enabled: true, requireBase: false });
  }
});