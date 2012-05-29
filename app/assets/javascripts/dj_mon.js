//= require bootstrap-tab
//= require mustache

$(function(){

  $('a[data-toggle="tab"]').bind('shown', function(e) {
    var currentTab = e.target;
    var tabContent = $($(currentTab).attr('href'));
    var dataUrl = tabContent.data('url');

    $.getJSON(dataUrl).success(function(data){
      var template = $('#dj_reports_template').html();
      if(data.length > 0)
        var output = Mustache.render(template, data);
      else
        var output = "<div class='alert alert-info centered'>No Jobs</div>";
      tabContent.html(output);
    });

  })

  $('.nav.nav-tabs li.active a[data-toggle="tab"]').trigger('shown');

  (function refreshCount() {
    $.getJSON('/dj_mon/dj_reports/dj_counts/').success(function(data){
      var template = $('#dj_counts_template').html();
      var output = Mustache.render(template, data);
      $('#dj-counts-view').html(output);
      setTimeout(refreshCount, 5000);
    });
  })();

})

