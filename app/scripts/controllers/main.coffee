'use strict'

###*
 # @ngdoc function
 # @name talkmoreApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the talkmoreApp
###

talkmoreAppControllers = angular.module 'talkmoreApp.controllers'

talkmoreAppControllers
  .controller 'MainCtrl', ($scope, _, $uibModal, $timeout, $log, apiFactory, apiPlans, apiPricing, apiDetails) ->

    initializing = true
    $scope.APIplans = apiPlans.data
    $scope.APIpricing = apiPricing.data
    $scope.APIdetails = apiDetails.data
    $scope.listPlans = $scope.APIplans

    $timeout ->
      $scope.APIplans.push
        plan: 'Normal'
        price: '0'


    firstState = $scope.APIplans

    $scope.ddd = origin: null
    $scope.ddd = destiny: null

    $scope.onlyNumbers = /^\d+$/
    $scope.animationsEnabled = true


    $scope.calcIncreasePrice = (planTime, priceMin, callTime) ->
      priceMinute = parseFloat(priceMin)
      planTime = parseInt(planTime, 10)
      increase = (10 / 100) * priceMinute
      newPrice = priceMinute + increase
      result = ((callTime - planTime) * newPrice).toFixed(2).replace(/\./, ',')
      return result


    $scope.calcNormalPrice = (priceMin, callTime) ->
      priceMinute = parseFloat(priceMin)
      result = (callTime * priceMin).toFixed(2).replace(/\./, ',')
      return result


    $handlecall = ->
      callTime = $scope.time
      tempArr = []
      filterDDDorigin =  $scope.ddd.origin
      filterDDDdestiny = $scope.ddd.destiny
      
      if $scope.frmPlan.$valid

        priceMinute = _.filter $scope.APIpricing, _.matches(
          'origin': '0' + filterDDDorigin
          'destiny': '0' + filterDDDdestiny)

        if _.isEmpty(priceMinute)
          _.extend(_.find($scope.listPlans, { plan: 'Normal' }), price: '-');

          $timeout ->
            $scope.notPlan = true
            return

        else
          $timeout ->
            $scope.notPlan = false
            return

          priceMinute = parseFloat(priceMinute[0].price)

          angular.forEach $scope.APIplans, (plan, index) ->
            planTime = parseInt(plan.time, 10)
            newPrice = $scope.calcIncreasePrice(planTime, priceMinute, callTime)

            if callTime > planTime
              tempArr.push
                plan: plan.plan
                price: newPrice
            else
              tempArr.push
                plan: plan.plan
                price: 'Gratis'
            return

          $scope.listPlans = tempArr
          _.extend(_.find($scope.listPlans, { plan: 'Normal' }), price: $scope.calcNormalPrice(priceMinute, callTime))


    $scope.changeMinutes = ->
      $handlecall()

    $scope.$watch 'frmPlan.$valid', (validaty) ->
      if initializing
        $timeout ->
          initializing = false
      else
        if !validaty
          $scope.listPlans = firstState
          $timeout ->
            $scope.notPlan = null
            return


    $scope.open = ($event) ->
      inputName = $event.target.name.split('-').pop()
      modalInstance = $uibModal.open(
        animation: true
        templateUrl: 'views/modal/ddd.html'
        controller: 'ModalInstanceCtrl'
        backdrop: 'static',
        size: 'sm'
        resolve:
          details: ->
            $scope.APIdetails
      )

      modalInstance.result.then ((getInfoDetails) ->
        $scope.ddd[inputName] = getInfoDetails.DDD
        $timeout ->
          $handlecall()
        return
      ), ->
        $log.info 'Modal dismissed at: ' + new Date
        return
      return


talkmoreAppControllers
  .controller 'ModalInstanceCtrl', ($scope, $uibModalInstance, details) ->
    $scope.modalDetails = details
    $scope.getInfo = DDD: null
    $scope.getInfo = city: null

    $scope.getInfoDetails = (ddd, city) ->
      $scope.getInfo.DDD = ddd
      $scope.getInfo.city = city
      $uibModalInstance.close $scope.getInfo

    $scope.cancel = ->
      $uibModalInstance.dismiss 'cancel'
      return
