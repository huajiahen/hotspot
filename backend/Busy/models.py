# -*- coding:utf-8 -*-
from django.db.models import *

class Event(Model):
    
    content = CharField(u'内容',max_length = 200)
    starttime = IntegerField(u'开始时间')
    endtime = IntegerField(u'结束时间')
    #longitude = DecimalField(u'经度',max_digits = 18,decimal_places = 14)
    #latitude = DecimalField(u'纬度',max_digits = 18,decimal_places = 14)
    longitude = FloatField(u'经度')
    latitude = FloatField(u'纬度')
    address = CharField(u'地点',max_length = 100)
    hit = IntegerField(u'想去数',default = 0)
       
class Emergency(Model):
    content = CharField(u'内容',max_length = 100)
    #longitude = DecimalField(u'经度',max_digits = 18,decimal_places = 14)
    #latitude = DecimalField(u'纬度',max_digits = 18,decimal_places = 14)
    longitude = FloatField(u'经度')
    latitude = FloatField(u'纬度')

class Man(Model):
    user_id = CharField(u'用户ID',max_length = 200)
    longitude = DecimalField(u'经度',max_digits = 18,decimal_places = 14)
    latitude = DecimalField(u'纬度',max_digits = 18,decimal_places = 14)
    hadevent = BooleanField(u'是否参与事件',default = False)
