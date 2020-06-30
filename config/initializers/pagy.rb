# typed: false
require 'pagy/extras/bootstrap'

Pagy::VARS[:items] = 25
Pagy::VARS[:breakpoints] = { 0 => [1,0,0,1], 540 => [2,3,3,2], 720 => [3,4,4,3] }
Rails.application.config.assets.paths << Pagy.root.join('javascripts')