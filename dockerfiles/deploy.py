connect( 'weblogic', 'welcome1', 't3://localhost:7001', adminServerName='AdminServer' )

stopApplication('tsam_wls12c')
undeploy('tsam_wls12c', targets='AdminServer')

deploy('tsam_wls12c', '/home/oracle/OraHome_1/tsam12.2.2.0.0/deploy/tsam_wls12c.ear', targets='AdminServer')
startApplication('tsam_wls12c')
