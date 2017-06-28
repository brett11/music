// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap
//= require turbolinks
//= require rails.validations
//= require_tree .

// $.ajaxSetup({
//     cache: true
// });

$(document).on('turbolinks:load', function() {
    // https://stackoverflow.com/questions/22281918/rails-turbolinks-break-submit-remote-form
    $(document).on("submit","#sort_alphabetically form",function () {
        $.ajax({
            url: this.action ,
            cache: true,
            type: 'GET',
            data: $(this).serialize(),
            dataType: 'script',
            success: function(data, success) {
                console.log("success", arguments);
                console.log("data", typeof data, data); // Verify the response
            },
            error: function(jqxhr, textStatus, error) {
                console.log("error", arguments);
            },
            complete: function(jqxhr, textStatus) {
                console.log("complete", arguments);
            }
        });
        return false;
    });

    $(document).on("submit", "#sort_by_id form", function () {
        $.ajax({
            url: this.action ,
            cache: true,
            type: 'GET',
            data: $(this).serialize(),
            dataType: 'script',
            success: function(data, success) {
                console.log("success", arguments);
                console.log("data", typeof data, data); // Verify the response
            },
            error: function(jqxhr, textStatus, error) {
                console.log("error", arguments);
            },
            complete: function(jqxhr, textStatus) {
                console.log("complete", arguments);
            }
        });
        return false;
    });

    $("#artists_search input").keyup(function() {
        $.get($("#artists_search").attr("action"), $("#artists_search").serialize(), null, "script");
        return false;
    });

});