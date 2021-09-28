<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="DXWebApplication1.Default" %>

<%@ Register Assembly="DevExpress.Web.ASPxGantt.v21.1, Version=21.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGantt" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="jquery-3.5.1.min.js"></script>
    <script type="text/javascript">
        function getTaskContentTemplate(s, e) {
            var $parentContainer = $(document.createElement("div"));

            appendPlannedTask(e.item.taskData, e.item.taskResources[0], e.item.taskSize.width, $parentContainer);
            appendActualTask(e.item.taskData, e.item.taskSize.width, $parentContainer);

            $parentContainer.appendTo(e.container);
        }

        function appendPlannedTask(taskData, resource, taskWidth, container) {
            var $plannedTaskContainer = $(document.createElement("div"))
                .addClass("planned-task")
                .attr("style", "width:" + taskWidth + "px;")
                .appendTo(container);

            var $wrapper = $(document.createElement("div"))
                .addClass("planned-task-wrapper")
                .appendTo($plannedTaskContainer);

            $(document.createElement("div"))
                .addClass("planned-task-title")
                .text(taskData.Title)
                .appendTo($wrapper);
            $(document.createElement("div"))
                .addClass("planned-task-resource")
                .text(resource ? resource.text : "")
                .appendTo($wrapper);

            $(document.createElement("div"))
                .addClass("planned-task-progress")
                .attr("style", "width:" + (parseFloat(taskData.Progress)) + "%;")
                .appendTo($plannedTaskContainer);
        }
        function appendActualTask(taskData, taskWidth, container) {
            var taskRange = taskData.EndDate - taskData.StartDate;
            var tickSize = taskWidth / taskRange;
            var actualTaskOffset = new Date(taskData.ActualStartDate) - taskData.StartDate;
            var actualTaskRange = new Date(taskData.ActualEndDate) - new Date(taskData.ActualStartDate);

            var actualTaskWidth = Math.round(actualTaskRange * tickSize) + "px";
            var actualTaskLeftPosition = Math.round(actualTaskOffset * tickSize) + "px";

            $(document.createElement("div"))
                .addClass("actual-task")
                .attr("style", "width:" + actualTaskWidth + "; left:" + actualTaskLeftPosition)
                .appendTo(container);
        }

    </script>
    <style>
        #Gantt_gtl_D tr:nth-child(n+2) {
            height: 63px;
        }

        .actual-task {
            height: 100%;
            display: inline-block;
            overflow: hidden;
            position: absolute;
            background-color: #92c3f2;
            opacity: 0.5;
            border-radius: 3px;
        }

        .planned-task {
            max-height: 48px;
            height: 100%;
            display: inline-block;
            overflow: hidden;
            border-radius: 3px 3px 0px 0px;
            background-color: #5C57C9;
        }

        .planned-task-wrapper {
            padding: 8px;
            color: #fff;
        }

            .planned-task-wrapper > * {
                display: block;
                overflow: hidden;
                text-overflow: ellipsis;
            }


        .planned-task-title {
            font-weight: 600;
            font-size: 13px;
        }

        .planned-task-resource {
            font-size: 12px;
        }

        .planned-task-progress {
            position: absolute;
            left: 0;
            bottom: 0;
            width: 0%;
            height: 4px;
            background: rgba(0, 0, 0, .5);
            border-radius: 0px 0px 0px 3px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxGantt ID="Gantt" runat="server"  Height="700" Width="100%" ClientInstanceName="clientGantt" EnableViewState="false"
            TasksDataSourceID="TasksDataSource"
            DependenciesDataSourceID="DependenciesDataSource"
            ResourcesDataSourceID="ResourcesDataSource"
            ResourceAssignmentsDataSourceID="ResourceAssignmentsDataSource">
            <ClientSideEvents TaskShowing="getTaskContentTemplate" />
            <SettingsToolbar>
                <Items>
                    <dx:GanttZoomInToolbarItem Text="Zoom In"></dx:GanttZoomInToolbarItem>
                    <dx:GanttZoomOutToolbarItem Text="Zoom Out"></dx:GanttZoomOutToolbarItem>
                </Items>
            </SettingsToolbar>
            <SettingsTaskList Width="40%" >
                <Columns>
                    <dx:GanttTextColumn FieldName="Title" Caption="Title" Width="360" />
                    <dx:GanttDateTimeColumn FieldName="StartDate" Visible="false" />
                    <dx:GanttDateTimeColumn FieldName="ActualStartDate" Visible="false" />
                    <dx:GanttDateTimeColumn FieldName="EndDate" Visible="false" />
                    <dx:GanttDateTimeColumn FieldName="ActualEndDate" Visible="false" />
                    <dx:GanttDataColumn FieldName="Progress" Visible="false" />
                </Columns>
            </SettingsTaskList>
            <Mappings>
                <Task Key="Key" ParentKey="ParentKey" Title="Title" Start="StartDate" End="EndDate" Progress="Progress" />
                <Dependency Key="Key" PredecessorKey="PredecessorKey" SuccessorKey="SuccessorKey" DependencyType="Type" />
                <Resource Key="Key" Name="Name" />
                <ResourceAssignment Key="Key" TaskKey="TaskKey" ResourceKey="ResourceKey" />
            </Mappings>
            <SettingsGanttView ViewType="Days" />
        </dx:ASPxGantt>


        <asp:ObjectDataSource ID="TasksDataSource" runat="server" TypeName="DXWebApplication1.GanttDataProvider" SelectMethod="GetTasks" />
        <asp:ObjectDataSource ID="DependenciesDataSource" runat="server" DataObjectTypeName="Dependency" TypeName="DXWebApplication1.GanttDataProvider" SelectMethod="GetDependencies" />
        <asp:ObjectDataSource ID="ResourcesDataSource" runat="server" DataObjectTypeName="Resource" TypeName="DXWebApplication1.GanttDataProvider" SelectMethod="GetResources" />
        <asp:ObjectDataSource ID="ResourceAssignmentsDataSource" runat="server" DataObjectTypeName="ResourceAssignment" TypeName="DXWebApplication1.GanttDataProvider" SelectMethod="GetResourceAssignments" />
    </form>
</body>
</html>
