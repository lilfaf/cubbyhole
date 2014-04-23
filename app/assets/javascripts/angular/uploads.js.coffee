#= require_self

root = global ? window

# Init module
uploads = angular.module('uploads', ['blueimp.fileupload'])

UploadsCtrl = ($scope, $http, $filter, $window) ->
  $scope.options =
    autoUpload: true

# Inject controller dependencies
UploadsCtrl.$inject = ['$scope', '$http', '$filter', '$window']

# Register controller
uploads.controller 'UploadsCtrl', UploadsCtrl

root.UploadsCtrl = UploadsCtrl
