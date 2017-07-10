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
//= require underscore
//= require bootstrap
//= require turbolinks
//= require rails.validations
//= require_tree .

// $.ajaxSetup({
//     cache: true
// });

$(document).on('turbolinks:load', function() {
    // https://stackoverflow.com/questions/22281918/rails-turbolinks-break-submit-remote-form
    // artists index sort alphabetically
    $(document).on("submit","#sort_alphabetically form", function () {
        $.ajax({
            url: this.action ,
            cache: true,
            type: 'GET',
            data: $(this).serialize(),
            dataType: 'script',
            // success: function(data, success) {
            //     console.log("success", arguments);
            //     console.log("data", typeof data, data); // Verify the response
            // },
            // error: function(jqxhr, textStatus, error) {
            //     console.log("error", arguments);
            // },
            // complete: function(jqxhr, textStatus) {
            //     console.log("complete", arguments);
            // }
        });
        return false;
    });

    // artists index sort by id
    $(document).on("submit", "#sort_by_id form", function () {
        $.ajax({
            url: this.action ,
            cache: true,
            type: 'GET',
            data: $(this).serialize(),
            dataType: 'script',
            // success: function(data, success) {
            //     console.log("success", arguments);
            //     console.log("data", typeof data, data); // Verify the response
            // },
            // error: function(jqxhr, textStatus, error) {
            //     console.log("error", arguments);
            // },
            // complete: function(jqxhr, textStatus) {
            //     console.log("complete", arguments);
            // }
        });
        return false;
    });

    // artists search-- replaced with below because needed cache:true option so wouldn't get unpermitted parameter of "_"
    // $("#artists_search input").keyup(function() {
    //     // debugger;
    //     $.get($("#artists_search").attr("action"), $("#artists_search").serialize(), null, "script");
    //     return false;
    // });

    // artists search full ajax version
    // used debounce to reduce amount of ajax calls made while typing
    $(document).on("keyup","#artists_search input", _.debounce(function () {
        $.ajax({
            url: $("#artists_search").attr("action"),
            cache: true,
            type: 'GET',
            data: $("#artists_search").serialize(),
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
    }, 200));

    // albums index sort by release date
    $(document).on("submit","#sort_release_date form", function () {
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

    // albums index sort alphabetically
    $(document).on("submit","#sort_alphabetically_album form", function () {
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

    // albums index sort alphabetically
    $(document).on("submit","#sort_alphabetically_by_artist form", function () {
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

    // // albums search -- replaced with below because needed cache:true option so wouldn't get unpermitted parameter of "_"
    // $("#albums_search input").keyup(function() {
    //     $.get($("#albums_search").attr("action"), $("#albums_search").serialize(), null, "script");
    //     return false;
    // });

    // albums search full ajax version
    $(document).on("keyup","#albums_search input", _.debounce(function () {
        $.ajax({
            url: $("#albums_search").attr("action") ,
            cache: true,
            type: 'GET',
            data: $("#albums_search").serialize(),
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
    }, 200));

    // $(".pagination a").on("click", function() {
    //     $.getScript(this.href);
    //     return false;
    // });

    //$("#sort_alphabetically_album form").css("border", "3px solid red");
    //https://stackoverflow.com/questions/31876393/using-nth-child-non-recursive
    // the below selects any div who is a direct descendant of #all_artists which is the first
    // child of its parent(which is #all_artists)
    //$("#all_artists > div:nth-child(1)").css("border", "3px solid red");

});