<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" 
    Inherits="Tareas_con_Prioridades.Default" 
    ViewStateEncryptionMode="Always" 
    EnableViewStateMac="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Panel de Control de Tareas con Prioridades</title>
    <style>
        /* Reset y base */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            color: #1a1a2e;
            line-height: 1.5;
        }

        /* Layout principal */
        .app-header {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: #fff;
            padding: 24px 32px;
            text-align: center;
        }
        .app-header h1 { font-size: 1.6rem; font-weight: 600; letter-spacing: 0.5px; }
        .app-header p  { font-size: 0.85rem; opacity: 0.75; margin-top: 4px; }

        .container {
            max-width: 960px;
            margin: 24px auto;
            padding: 0 16px;
        }

        /* Contadores */
        .stats-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .stat-card {
            flex: 1;
            min-width: 130px;
            background: #fff;
            border-radius: 8px;
            padding: 14px 18px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            text-align: center;
        }
        .stat-card .stat-number { font-size: 1.8rem; font-weight: 700; color: #0f3460; }
        .stat-card .stat-label  { font-size: 0.75rem; text-transform: uppercase; color: #888; letter-spacing: 0.5px; }
        .stat-card.pendiente .stat-number { color: #e67e22; }
        .stat-card.progreso  .stat-number { color: #2980b9; }
        .stat-card.completada .stat-number { color: #27ae60; }

        /* Paneles */
        .panel {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            padding: 24px;
            margin-bottom: 20px;
        }
        .panel-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 2px solid #f0f2f5;
        }

        /* Formulario */
        .form-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            flex: 1;
            min-width: 160px;
        }
        .form-group label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #555;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .form-group input[type="text"],
        .form-group select {
            padding: 9px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: border-color 0.2s;
            background: #fafbfc;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0f3460;
            box-shadow: 0 0 0 3px rgba(15,52,96,0.1);
        }
        .btn {
            padding: 9px 20px;
            border: none;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            letter-spacing: 0.3px;
        }
        .btn-primary {
            background: #0f3460;
            color: #fff;
        }
        .btn-primary:hover { background: #1a4a7a; }
        .btn-success {
            background: #27ae60;
            color: #fff;
        }
        .btn-success:hover { background: #219a52; }
        .btn-danger {
            background: #c0392b;
            color: #fff;
        }
        .btn-danger:hover { background: #a93226; }
        .btn-sm {
            padding: 5px 12px;
            font-size: 0.78rem;
        }

        /* Validacion */
        .validation-msg {
            color: #c0392b;
            font-size: 0.8rem;
            margin-top: 8px;
        }

        /* Filtros */
        .filters-row {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .filters-row label.filtro-title {
            font-weight: 600;
            font-size: 0.85rem;
            color: #555;
        }
        /* RadioButtonList horizontal */
        .filter-rbl table { border-spacing: 0; }
        .filter-rbl td { padding: 0 14px 0 0; }
        .filter-rbl label {
            font-size: 0.85rem;
            cursor: pointer;
            color: #333;
        }
        .filter-rbl input[type="radio"] { margin-right: 4px; }

        /* Tabla de tareas */
        .task-table {
            width: 100%;
            border-collapse: collapse;
        }
        .task-table th {
            background: #1a1a2e;
            color: #fff;
            padding: 10px 14px;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-align: left;
        }
        .task-table th:first-child { border-radius: 6px 0 0 0; }
        .task-table th:last-child  { border-radius: 0 6px 0 0; }
        .task-table td {
            padding: 10px 14px;
            font-size: 0.88rem;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        .task-table tr:hover td { background: #f8f9fb; }
        .task-table tr:last-child td { border-bottom: none; }

        /* Badges prioridad */
        .badge {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-alta      { background: #fdecea; color: #c0392b; }
        .badge-media      { background: #fef3e2; color: #e67e22; }
        .badge-baja       { background: #e8f8f0; color: #27ae60; }

        /* Colores estado */
        .estado-pendiente   { color: #e67e22; font-weight: 600; }
        .estado-enprogreso  { color: #2980b9; font-weight: 600; }
        .estado-completada  { color: #27ae60; font-weight: 600; }

        /* Vacio */
        .empty-msg {
            text-align: center;
            padding: 40px 20px;
            color: #999;
            font-size: 0.95rem;
        }

        /* Acciones masivas */
        .bulk-actions {
            display: flex;
            gap: 10px;
            margin-top: 16px;
            flex-wrap: wrap;
        }

        /* Badge de seguridad */
        .security-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e8f5e9;
            color: #2e7d32;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.72rem;
            font-weight: 600;
            margin-top: 6px;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .form-row { flex-direction: column; }
            .form-group { min-width: 100%; }
            .stats-bar { flex-direction: column; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header -->
        <div class="app-header">
            <h1>Panel de Control de Tareas con Prioridades</h1>
            <p>Ejercicio 05 - ViewState en ASP.NET WebForms</p>
            <span class="security-badge">ViewState Encriptado + MAC Habilitado</span>
        </div>

        <div class="container">

            <!-- Contadores de tareas por estado (Requisito 5) -->
            <div class="stats-bar">
                <div class="stat-card">
                    <div class="stat-number">
                        <asp:Label ID="lblTotal" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">Total</div>
                </div>
                <div class="stat-card pendiente">
                    <div class="stat-number">
                        <asp:Label ID="lblPendientes" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">Pendientes</div>
                </div>
                <div class="stat-card progreso">
                    <div class="stat-number">
                        <asp:Label ID="lblEnProgreso" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">En Progreso</div>
                </div>
                <div class="stat-card completada">
                    <div class="stat-number">
                        <asp:Label ID="lblCompletadas" runat="server" Text="0" />
                    </div>
                    <div class="stat-label">Completadas</div>
                </div>
            </div>

            <!-- Formulario para agregar tarea (Requisito 1) -->
            <div class="panel">
                <div class="panel-title">Agregar Nueva Tarea</div>
                <div class="form-row">
                    <div class="form-group" style="flex:2;">
                        <label for="txtDescripcion">Descripcion</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" 
                            placeholder="Escribe la descripcion de la tarea..." />
                    </div>
                    <div class="form-group">
                        <label for="txtResponsable">Responsable</label>
                        <asp:TextBox ID="txtResponsable" runat="server" 
                            placeholder="Nombre del responsable..." />
                    </div>
                    <div class="form-group">
                        <label for="ddlPrioridad">Prioridad</label>
                        <asp:DropDownList ID="ddlPrioridad" runat="server">
                            <asp:ListItem Value="Alta" Text="Alta" />
                            <asp:ListItem Value="Media" Text="Media" Selected="True" />
                            <asp:ListItem Value="Baja" Text="Baja" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="flex:0 0 auto;">
                        <label>&nbsp;</label>
                        <asp:Button ID="btnAgregar" runat="server" Text="Agregar Tarea" 
                            CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
                    </div>
                </div>
                <asp:Label ID="lblMensaje" runat="server" CssClass="validation-msg" />
            </div>

            <!-- Filtros por estado (Requisito 3) -->
            <div class="panel">
                <div class="filters-row">
                    <label class="filtro-title">Filtrar por estado:</label>
                    <asp:RadioButtonList ID="rblFiltros" runat="server" 
                        RepeatDirection="Horizontal" 
                        AutoPostBack="true"
                        CssClass="filter-rbl"
                        OnSelectedIndexChanged="rblFiltros_SelectedIndexChanged">
                        <asp:ListItem Value="Todos" Text="Todos" Selected="True" />
                        <asp:ListItem Value="Pendiente" Text="Pendiente" />
                        <asp:ListItem Value="EnProgreso" Text="En Progreso" />
                        <asp:ListItem Value="Completada" Text="Completada" />
                    </asp:RadioButtonList>
                </div>
            </div>

            <!-- Lista de tareas con Repeater (Requisito 2) -->
            <div class="panel" style="padding: 0; overflow: hidden;">
                <asp:Repeater ID="rptTareas" runat="server" 
                    OnItemCommand="rptTareas_ItemCommand">
                    
                    <HeaderTemplate>
                        <table class="task-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Descripcion</th>
                                    <th>Responsable</th>
                                    <th>Prioridad</th>
                                    <th>Estado</th>
                                    <th>Fecha</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("Id") %></td>
                            <td><%# Eval("Descripcion") %></td>
                            <td><%# Eval("Responsable") %></td>
                            <td>
                                <span class='<%# "badge badge-" + Eval("Prioridad").ToString().ToLower() %>'>
                                    <%# Eval("Prioridad") %>
                                </span>
                            </td>
                            <td>
                                <span class='<%# "estado-" + Eval("Estado").ToString().ToLower() %>'>
                                    <%# FormatearEstado(Eval("Estado").ToString()) %>
                                </span>
                            </td>
                            <td><%# Eval("FechaCreacion", "{0:dd/MM/yyyy HH:mm}") %></td>
                            <td>
                                <asp:Button ID="btnCambiarEstado" runat="server" 
                                    CommandName="CambiarEstado" 
                                    CommandArgument='<%# Eval("Id") %>'
                                    Text='<%# ObtenerTextoBotonEstado(Eval("Estado").ToString()) %>'
                                    CssClass='<%# "btn btn-sm " + ObtenerClaseBotonEstado(Eval("Estado").ToString()) %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

                <!-- Panel vacio cuando no hay tareas -->
                <asp:Panel ID="pnlVacio" runat="server" Visible="false">
                    <div class="empty-msg">
                        No hay tareas para mostrar. Agrega una nueva tarea arriba.
                    </div>
                </asp:Panel>
            </div>

            <!-- Acciones masivas (Requisito 6) -->
            <div class="bulk-actions">
                <asp:Button ID="btnMarcarTodas" runat="server" 
                    Text="Marcar todas como completadas" 
                    CssClass="btn btn-success" 
                    OnClick="btnMarcarTodas_Click" />
                <asp:Button ID="btnEliminarCompletadas" runat="server" 
                    Text="Eliminar completadas" 
                    CssClass="btn btn-danger" 
                    OnClick="btnEliminarCompletadas_Click" />
            </div>

        </div>
    </form>
</body>
</html>
