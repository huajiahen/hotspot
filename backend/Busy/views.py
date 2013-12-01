# -*-coding:utf-8-*-
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.utils import simplejson
from Busy.models import Event,Emergency,Man
from Busy import BusyJpush
import logging
SEND_MSG_URL = 'http://api.jpush.cn:8800/v2/push'
REQUIRED_KEYS = set(('receiver_type','msg_type','msg_content','platform'))

DVALUE = 0.00005

#返回用户活动事件信息
def man_return(request):
    DVALUE = 0.05
    if request.method=="POST":
        longitude = float(request.POST.get("longitude"))
        latitude = float(request.POST.get("latitude"))
        mylongitude = longitude
        mylatitude = latitude
        man_id =request.POST.get("id")
        if not Man.objects.filter(user_id = man_id):
            new_man= Man(user_id = man_id,longitude = mylongitude,latitude = mylatitude)
            new_man.save()
        all_event = Event.objects.all()
        near_event = []
        if all_event:
            for i in all_event:
             #   if ((i.longitude < DVALUE+longitude)and(i.longitude>longitude-DVALUE)and(i.latitude<latitude+DVALUE)and(i.latitude>latitude-DVALUE)):
                near_event.append({'content':i.content+u'','starttime':i.starttime,'endtime':i.endtime,'longitude':i.longitude,'latitude':i.latitude,'address':i.address+u''})
        all_emergency = Emergency.objects.all()
        near_emergencycontent = [] 
        near_emergencylongitude = []
        near_emergencylatitude = []
        near_emergency = []
        if all_emergency:
            for i in all_emergency:
              #  if ((i.longitude < DVALUE+longitude)and(i.longitude>longitude-DVALUE)and(i.latitude<latitude+DVALUE)and(i.latitude>latitude-DVALUE)):
                near_emergency.append({'content':i.content+u'','longitude':i.longitude,'latitude':i.latitude})
        data = {
                "near_event":near_event,
                "near_emergency":near_emergency
        }
        mimetype = 'application/json'
        return HttpResponse(simplejson.dumps(data,ensure_ascii = False),mimetype = mimetype)
    return HttpResponse("Hello,HackDay!")

def posttest(request):
    event = Event.objects.all()
    emergency = Emergency.objects.all()
    return render_to_response("posttest.html",locals())
#emergency发送
def emergency_send(request):
    if request.method=="POST":
        man_id = request.POST.get("id")
        #存储事件
        emergency_longitude = request.POST.get("longitude")
        emergency_latitude = request.POST.get("latitude")
        emergency_content = u''+request.POST.get("content")
     #   new_man= Man(user_id = man_id,longitude = emergency_longitude,latitude = emergency_latitude,hadevent = False)
     #   new_man.save()
        myemergency = Emergency(longitude = emergency_longitude,latitude = emergency_latitude,content = emergency_content)
        myemergency.save()
        #事件推送
      #  BusyJpush.logger.addHandler(logging.StreamHandler())
      #  BusyJpush.logger.setLevel(logging.DEBUG)

      #  client = JpushPy('app_key','master_secret')
      #  params = dict(
      #      receiver_type = 4,
      #      msg_type = 1,
      #      msg_content = {'n_content':emergency_content,'n_extras':{"longitude":emergency_longitude,"latitude":emergency_latitude
      #      }}
      #  )
      #  client.send_msg(params)
    return HttpResponse("")
        
#event发送
def event_send(request):
    if request.method=="POST":
        event_longitude = request.POST.get("longitude")
        event_latitude = request.POST.get("latitude")
        man_id = request.POST.get("id")
        if not Man.objects.filter(user_id = man_id): 
            new_man= Man(user_id = man_id,longitude = event_longitude,latitude = event_latitude)
            new_man.save()
        if (request.POST.get("content"))and(request.POST.get("longitude"))and(request.POST.get("latitude"))and(request.POST.get("address")):
            event_content = u''+request.POST.get("content")
            event_longitude = request.POST.get("longitude")
            event_latitude = request.POST.get("latitude")
            event_starttime = int(request.POST.get("starttime"))
            event_endtime = int(request.POST.get("endtime"))
            event_address = request.POST.get("address")
            myevent = Event(content = event_content,longitude = event_longitude,latitude = event_latitude,starttime = event_starttime,endtime = event_endtime,address = event_address)
            myevent.save() 
    return HttpResponse("")
def test(request):
    return HttpResponse("Hello")
#点赞请求
#def hit_send(request):
#    if request.method=="POST":
#        try:
#            Event.objects.get()
