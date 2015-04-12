'use strict'

userService = angular.module('userService', ['ngResource'])
userService.config(['$resourceProvider', ($resourceProvider)->
	$resourceProvider.defaults.actions.update =
		method: 'PUT'
])

userService.factory('Info', ['$resource', ($resource)->
	$resource('/user/info')
])

userService.factory('Order', ['$resource', ($resource)->
	$resource('/user/order')
])