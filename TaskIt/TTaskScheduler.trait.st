"
I am a trait implementing the main behavior of a task scheduler. That is, I define as requirement a #schedule: message and I define #future: on top of #schedule:.
"
Trait {
	#name : #TTaskScheduler,
	#category : 'TaskIt-Kernel'
}

{ #category : #schedulling }
TTaskScheduler >> future: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	self scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #schedulling }
TTaskScheduler >> privateTimeout: timeout on: aTaskExecution [
	timeout wait.
	aTaskExecution isFinished
		ifFalse: [ aTaskExecution cancelWithReason: 'Timeout after: ' , timeout asString ]
]

{ #category : #schedulling }
TTaskScheduler >> schedule: aTask [
	| execution |
	execution := aTask asTask scheduleTaskExecutionFor: self.
	self scheduleTaskExecution: execution
	
]

{ #category : #schedulling }
TTaskScheduler >> schedule: aTask timeout: aTimeout [

	| execution |
	execution := TKTTimeoutableTaskExecution new.
	execution runner: self.
	execution task: aTask.
	execution timeout: aTimeout.
	
	self scheduleTaskExecution: execution.
]

{ #category : #schedulling }
TTaskScheduler >> scheduleTaskExecution: aTaskExecution [

	self requirement
]

{ #category : #schedulling }
TTaskScheduler >> scheduleTimeout: timeout on: aTaskExecution [
	TKTConfiguration processProvider
		createProcessDoing:
			(MessageSend
				receiver: self
				selector: #privateTimeout:on:
				arguments:
					{timeout.
					aTaskExecution})
]