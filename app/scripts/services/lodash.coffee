'use strict'

###*
 # @ngdoc service
 # @name talkmoreApp.lodash
 # @description
 # # lodash
 # Service in the talkmoreApp.
###
talkmoreAppServices = angular.module 'talkmoreApp.services'

talkmoreAppServices
  .factory '_', ($window) ->
    # place lodash include before angular
    return $window._
