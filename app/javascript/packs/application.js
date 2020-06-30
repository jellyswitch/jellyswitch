/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

console.log('Hello World from Jellyswitch!')

import Rails from '@rails/ujs';
Rails.start();

require("@rails/activestorage").start()
require("trix")
require("@rails/actiontext")
require("turbolinks").start()

require("chartkick")
require("chart.js")

import ahoy from "ahoy.js";
window.ahoy = ahoy

import 'bootstrap'

// This is required to get Turbolinks 5 to work with non-GET form errors
// see https://github.com/turbolinks/turbolinks/issues/85#issuecomment-219799657
// for more information

document.addEventListener("turbolinks:load", () => {
  document.body.addEventListener("ajax:error", (e) => {
    if (e.detail[2].status !== 422) {
      return
    }
    document.body = e.detail[0].body
    Turbolinks.dispatch("turbolinks:load")
    scrollTo(0, 0)
  })
})

import './pagy.js.erb'
