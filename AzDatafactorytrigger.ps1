$resourceGroupName = "ResourceGroupName"
$dataFactoryName   = "DataFactrotyName"
$triggerName       = "TriggerName"
$currentTime       = Get-Date

$recurrence   = (Get-AzDataFactoryV2Trigger -ResourceGroupName $resourceGroupName -DataFactoryName $dataFactoryName -Name $triggerName).Properties.Recurrence
$RuntimeState = (Get-AzDataFactoryV2Trigger -ResourceGroupName $resourceGroupName -DataFactoryName $dataFactoryName -Name $triggerName).RuntimeState

$startTime = $recurrence.StartTime
$interval  = $recurrence.Interval
$frequency = $recurrence.Frequency

$startTimeDate   = [datetime]::Parse($startTime)
$startTimeHour   = $startTimeDate.Hour
$startTimeMinute = $startTimeDate.Minute

if($frequency -eq "Hour")
{
    $timeSpan = New-TimeSpan -Hours $interval
    $previousTime = $currentTime.Add($timeSpan)
   
    if(($previousTime.Hour -eq $startTimeHour) -and ($previousTime.Minute -ge $startTimeMinute))
    {
        if($RuntimeState -eq "Stopped")
        {
          # Write your action
          Write-host "Running hour block"
        }
    }
}elseif($frequency -eq "Day")
{
    $timeSpan = New-TimeSpan -Days $interval
    $previousTime = $currentTime.Add($timeSpan)
   
    if(($previousTime.Day -eq $startTimeDate.Day) -and ($previousTime.Hour -eq $startTimeHour) -and ($previousTime.Minute -ge $startTimeMinute))
    {
      if($RuntimeState -eq "Stopped")
      {
        # Write your action
        Write-host "Running Day block"
      }
    }
}elseif($frequency -eq "Week")
{
    $timeSpan = New-TimeSpan -Days ($interval * 7)
    $previousTime = $currentTime.Add($timeSpan)
   
    if(($previousTime.DayOfWeek -eq $startTimeDate.DayOfWeek) -and ($previousTime.Hour -eq $startTimeHour) -and ($previousTime.Minute -ge $startTimeMinute))
    {
      if($RuntimeState -eq "Stopped")
      {
        # Write your action
        Write-host "Running week block"
      }
    }
}elseif($frequency -eq "Month")
{
    $timeSpan = New-TimeSpan -Months $interval
    $previousTime = $currentTime.Add($timeSpan)
   
    if(($previousTime.Day -eq $startTimeDate.Day) -and ($previousTime.Hour -eq $startTimeHour) -and ($previousTime.Minute -ge $startTimeMinute))
    {
      if($RuntimeState -eq "Stopped")
      {
        # Write your action
        Write-host "Running Month block"
      }
    }
}
