# -*- coding:utf-8 -*-
import copy
import urllib, urllib2
import json
import logging
import hashlib
import time

logger = logging.getLogger('jpush_py')

SEND_MSG_URL = 'http://api.jpush.cn:8800/sendmsg/v2/sendmsg'
REQUIRED_KEYS = set(('receiver_type', 'msg_type', 'msg_content','platform'))

class JPushPy(object):
    '''jpush's python client'''

    _sendno = None

    def __init__(self,app_key,master_secret):
        if self.__class__.sendno is None:
            self.__class__.sendno = int (time.time())
        self._app_key = app_key
        self._master_secret = master_secret

    @classmethod
    def generate_sendno(cls):
        
        cls._sendno +=1
        return cls._sendno
    def generate_verification_code(self,params):
        '''生成验证码'''
        m = hashlib.md5()
        str = "%s%s%s%s" % (params['sendno'], params['receiver_type'], params.get('receiver_value',''),self._master_secret)
        m.update(str)
        return m.hexdigest().upper()   #??????

    def generate_params(self,params):
        '''
        生成新的params
        '''
        new_params = dict()

        sendno = params.get('sendno',self.generate_sendno())

        for k,v in params.items():
            if k =='msg_content' and isinstance(v,basestring):
                if params['msg_type']  == 1:
                    v = dict(
                        n_content = v
                    )
            if isinstance(v,dict):
                new_params[k] = json.dumps(v)
            elif isinstance(v,unicode):
                new_params[k] = v.encode('utf-8')
            else:
                new_params[k] = v
    
        new_params['sendno'] = sendno
        new_params['app_key'] = self.app_key
        new_params['verification_code'] = self.generate_verification_code(new_params)

    def send_msg(self, params, timeout = None):
        '''
        发送消息
        '''
        #Debug
        logger.debug('params: '+repr(params))

        if len(REQUIRED_KEYS & set(params.keys())) != len(REQUIRED_KEYS):
            return dict(
                sendno = params.get('sendno',None),
                errcode = -1000,
                errmsg = u'参数错误',
            )
        new_params = self.generate_params(params)

        logger.debug('new_params: ' + repr(new_params))

        encode_params = urllib.urlencode(new_params)

        try:
            data = urllib2.urlopen(SEND_MSG_URL, encode_params, timeout).read()
        except Exception, e:
            logger.error('exception occur.msg[%s], traceback[%s]' %(str(e),__import__('traceback').format_exc()))
            return dict(
                sendno = new_params['sendno'],
                errcode = -1001,
                errmsg = u'网络错误',

            )
        try:
            jdata = json.loads(data)
        except Exception,e:
            logger.error('exception occur.msg[%s], traceback[%s]' % (str(e), __import__('traceback').format_exc()))
            return dict(
                sendno = new_params['sendno'],
                errcode = -1002,
                errmsg = u'返回包解析错误',
            
            )
        return jdata
if __name__=='__main__':
    import logging
    import BusyJpush

    BusyJpush.logger.addHandler(logging.StreamHandler())
    BusyJpush.logger.setLevel(logging.DEBUG)

    client = BusyJpush.JPushPy('your app_key','your master secret')
    params = dict(
        receiver_type = 4,
        msg_type = 1,
        msg_content = u'富士，你为什么放弃治疗～',
        platform = 'ios' #大小写？
    )
    print client.send_msg(params,10)
