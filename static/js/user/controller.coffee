'use strict'

userCtrl = angular.module('userCtrl', ['ngCookies', 'ui.bootstrap'])

userCtrl.controller 'accordionCtrl', ['$scope', '$location', '$cookies', ($scope, $location, $cookies)->
	$(document).ready ->
		heading = $(document.querySelectorAll('.panel-heading'))
		heading.on 'click', ->
			heading.removeClass('open')
			$(this).addClass('open')

		entry = $(document.querySelectorAll('.panel-group p'))
		entry.on 'click', ->
			entry.removeClass('active')
			$(this).addClass('active')

		link = $(document.querySelector("[href='##{$location.path()}']"))
		link.parent().click()
		$($(link.parent().parent().parent().parent().children()[0]).children()[0]).children().click()

	$scope.logout = ->
		if confirm('退出当前账号？')
			for key, value of $cookies
				delete $cookies[key]
			window.location = '/'
]

userCtrl.controller 'orderActiveCtrl', ['$scope', '$filter', 'Order', 'Info', ($scope, $filter, Order, Info)->
	$scope.orderList = Order.userActive()
	$scope.info = Info.get()

	$scope.upgrade = ->
		self = this

		if self.order.status == 2
			if self.info.groupName?
				if not confirm('确认通过' + $scope.info.groupName + '支付？')
					return
			else
				alert('你还没有加入任何科研团体，请与科学指南针联系')
				return

		payload =
			status: self.order.status + 1
			ID: self.order.ID
		
		Order.update(payload).$promise.then ->
			alert('操作成功')
			self.order.status += 1
		, ->
			alert('操作失败')

	$scope.cancel = ->
		if confirm($filter('translate')('confirmCancel'))
			self = this
			payload =
				orderID: self.order.ID
			Order.cancel(payload).$promise.then ->
				alert($filter('translate')('orderCanceled'))
				self.order.status = 'CANCEL'
			, ->
				alert($filter('translate')('orderCancelFail'))
]

userCtrl.controller 'personalInfoCtrl', ['$scope', 'Info', ($scope, Info)->
	$scope.info = Info.get()
	$scope.password = {}

	$scope.updateInfo = ->
		Info.update($scope.info).$promise.then ->
			alert('更新信息成功')
		, ->
			alert('更新信息失败')

	$scope.updatePassword = ->
		if $scope.password.newPassword?
			if $scope.password.newPassword == $scope.password.newPasswordAgain
				Info.save($scope.password).$promise.then ->
					alert('修改密码成功')
				, ->
					alert('修改密码失败')
			else
				alert('两次输入的新密码不一致')
		else
			alert('请输入密码')
]
