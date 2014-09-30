# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require react/react-with-addons
#= require hidpi-canvas
#= require lodash/dist/lodash.min
#= require hammerjs
#= require hammer-jquery/jquery.hammer
#= require_tree .

timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]


appNode = document.getElementById('main')
# React.renderComponent(@.EpochUI.TimelineSearch(timelines: timeline), appNode)
React.renderComponent(@.EpochUI.TodoList(), appNode)
