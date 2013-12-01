from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('Busy.views',
    # Examples:
    # url(r'^$', 'Hack_Busy.views.home', name='home'),
    # url(r'^Hack_Busy/', include('Hack_Busy.foo.urls')),
    url(r'^api/emergency$','emergency_send'),
    url(r'^api/event$','event_send'),
    url(r'^api/updatelocation$','man_return'),
    #url(r'^test$','test'),
    url(r'^posttest$','posttest')
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
