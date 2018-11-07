# PLRTCStreamingKit 3.1.0 to 3.2.0 API Differences

```
PLRTCVideoView.h
```  
- *Added* method `- (void)setRenderMode:(PLRTCVideoRenderMode)mode;`

- *Deprecated* method `-(instancetype)init __attribute__((unavailable("init not available, call initWithFrame instead")));`

- *Deprecated* method `-(instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder not available, call initWithFrame instead")));
`


```
PLTypeDefines.h
```
- *Added* Type `PLRTCVideoRenderMode`

- *Modified* Type `PLRTCState`
    - *Added* `PLRTCStateConferenceReconnecting`
