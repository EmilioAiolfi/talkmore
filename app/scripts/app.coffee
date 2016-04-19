'use strict'

###*
 # @ngdoc overview
 # @name talkmoreApp
 # @description
 # # talkmoreApp
 #
 # Main module of the application.
###

# Submodules
# angular.module 'talkmoreApp.directives', []
angular.module 'talkmoreApp.services', []
angular.module 'talkmoreApp.controllers', []


angular
  .module('talkmoreApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngTouch',
    'restangular',
    'ui.bootstrap',
    'ui.router',
    'angular-loading-bar',

    'talkmoreApp.services',
    'talkmoreApp.controllers'
  ])
  .config (
    $stateProvider,
    $urlRouterProvider,
    $locationProvider,
    RestangularProvider,
    $interpolateProvider,
    cfpLoadingBarProvider
  ) ->
    $locationProvider.html5Mode true
    cfpLoadingBarProvider.latencyThreshold = 100;

    # For any unmatched url, redirect to /
    # $urlRouterProvider.otherwise '/'

    RestangularProvider
      .setBaseUrl 'http://private-36747-talkmore.apiary-mock.com/'

    $interpolateProvider.startSymbol "{{"
    $interpolateProvider.endSymbol "}}"

    $stateProvider
      .state('home',
        url: '/'
        resolve:
          apiPlans: (apiFactory) ->
            apiFactory.getPlans()

          apiPricing: (apiFactory) ->
            apiFactory.getPricing()

          apiDetails: (apiFactory) ->
            apiFactory.getDetails()

        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      )
      .state('404',
        url: '/404'
        templateUrl: 'views/404.html'
        controller: 'AboutCtrl'
      )

    $urlRouterProvider.otherwise ($injector) ->
      $injector.invoke ($state) ->
        $state.transitionTo '404', {}, false
        return
      return
