using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Tareas_con_Prioridades
{
    public partial class Default : System.Web.UI.Page
    {
        // Lista de tareas guardada en ViewState para persistir entre postbacks.
        // Como la clase Tarea tiene [Serializable], se puede almacenar directamente.
        private List<Tarea> MisTareas
        {
            get
            {
                if (ViewState["MisTareas"] == null)
                {
                    ViewState["MisTareas"] = new List<Tarea>();
                }
                return (List<Tarea>)ViewState["MisTareas"];
            }
            set
            {
                ViewState["MisTareas"] = value;
            }
        }

        // Filtro activo en ViewState (Requisito 4).
        // Se mantiene entre postbacks sin necesidad de cookies o sesion.
        private string FiltroActivo
        {
            get => ViewState["Filtro"] as string ?? "Todos";
            set => ViewState["Filtro"] = value;
        }

        // Criterio de orden guardado en ViewState (Requisito 4).
        private string OrdenActivo
        {
            get => ViewState["Orden"] as string ?? "FechaDesc";
            set => ViewState["Orden"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Solo en la primera carga (no en postbacks) se inicializa la vista.
            // IsPostBack es false la primera vez y true en cada postback.
            if (!IsPostBack)
            {
                BindTareas();
            }
        }

        // Filtra, ordena y enlaza las tareas al Repeater. Tambien actualiza los contadores.
        private void BindTareas()
        {
            var todasLasTareas = MisTareas;

            // Aplicar filtro segun el valor del RadioButtonList guardado en ViewState
            var tareasFiltradas = todasLasTareas.AsEnumerable();

            if (FiltroActivo != "Todos")
            {
                tareasFiltradas = todasLasTareas.Where(t => t.Estado.ToString() == FiltroActivo);
            }

            // Ordenar por fecha, las mas recientes primero
            var tareasOrdenadas = tareasFiltradas.OrderByDescending(t => t.FechaCreacion).ToList();

            // Enlazar al Repeater con DataSource y DataBind
            rptTareas.DataSource = tareasOrdenadas;
            rptTareas.DataBind();

            // Si no hay tareas, mostrar el panel vacio en lugar de la tabla
            bool hayTareas = tareasOrdenadas.Count > 0;
            rptTareas.Visible = hayTareas;
            pnlVacio.Visible = !hayTareas;

            // Actualizar los contadores de la parte superior (Requisito 5)
            ActualizarContadores(todasLasTareas);
        }

        // Cuenta las tareas por estado y actualiza los Labels del encabezado
        private void ActualizarContadores(List<Tarea> tareas)
        {
            lblTotal.Text = tareas.Count.ToString();
            lblPendientes.Text = tareas.Count(t => t.Estado == EstadoTarea.Pendiente).ToString();
            lblEnProgreso.Text = tareas.Count(t => t.Estado == EstadoTarea.EnProgreso).ToString();
            lblCompletadas.Text = tareas.Count(t => t.Estado == EstadoTarea.Completada).ToString();
        }

        // Evento del boton Agregar (Requisito 1).
        // Lee los valores del TextBox y DropDownList y crea una nueva Tarea.
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            string descripcion = txtDescripcion.Text.Trim();
            string responsable = txtResponsable.Text.Trim();

            // Validaciones basicas
            if (string.IsNullOrEmpty(descripcion))
            {
                lblMensaje.Text = "La descripcion es obligatoria.";
                return;
            }

            if (string.IsNullOrEmpty(responsable))
            {
                lblMensaje.Text = "El responsable es obligatorio.";
                return;
            }

            // Parsear la prioridad seleccionada en el DropDownList
            Prioridad prioridadSeleccionada = (Prioridad)Enum.Parse(typeof(Prioridad), ddlPrioridad.SelectedValue);

            // Generar Id unico basado en el maximo actual
            Tarea nueva = new Tarea
            {
                Id = MisTareas.Count > 0 ? MisTareas.Max(t => t.Id) + 1 : 1,
                Descripcion = descripcion,
                Prioridad = prioridadSeleccionada,
                Estado = EstadoTarea.Pendiente,
                Responsable = responsable,
                FechaCreacion = DateTime.Now
            };

            // Agregar a la lista y reasignar al ViewState
            var lista = MisTareas;
            lista.Add(nueva);
            MisTareas = lista;

            // Limpiar los campos del formulario
            txtDescripcion.Text = string.Empty;
            txtResponsable.Text = string.Empty;
            ddlPrioridad.SelectedIndex = 1; // Volver a "Media"
            lblMensaje.Text = string.Empty;

            BindTareas();
        }

        // Evento del RadioButtonList (Requisito 3).
        // Guarda el filtro seleccionado en ViewState y refresca la lista.
        protected void rblFiltros_SelectedIndexChanged(object sender, EventArgs e)
        {
            FiltroActivo = rblFiltros.SelectedValue;
            BindTareas();
        }

        // Evento ItemCommand del Repeater (Requisito 2).
        // Se dispara al hacer clic en un boton dentro del ItemTemplate.
        // CommandName identifica la accion, CommandArgument trae el Id de la tarea.
        protected void rptTareas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CambiarEstado")
            {
                int tareaId = Convert.ToInt32(e.CommandArgument);

                var lista = MisTareas;
                var tarea = lista.FirstOrDefault(t => t.Id == tareaId);

                if (tarea != null)
                {
                    // Ciclo de estados: Pendiente -> EnProgreso -> Completada -> Pendiente
                    switch (tarea.Estado)
                    {
                        case EstadoTarea.Pendiente:
                            tarea.Estado = EstadoTarea.EnProgreso;
                            break;
                        case EstadoTarea.EnProgreso:
                            tarea.Estado = EstadoTarea.Completada;
                            break;
                        case EstadoTarea.Completada:
                            tarea.Estado = EstadoTarea.Pendiente;
                            break;
                    }

                    MisTareas = lista; // Guardar cambios en ViewState
                }

                BindTareas();
            }
        }

        // Marcar todas las tareas como completadas (Requisito 6)
        protected void btnMarcarTodas_Click(object sender, EventArgs e)
        {
            var lista = MisTareas;

            foreach (var tarea in lista)
            {
                tarea.Estado = EstadoTarea.Completada;
            }

            MisTareas = lista;
            BindTareas();
        }

        // Eliminar las tareas con estado Completada (Requisito 6)
        protected void btnEliminarCompletadas_Click(object sender, EventArgs e)
        {
            var lista = MisTareas;
            lista.RemoveAll(t => t.Estado == EstadoTarea.Completada);
            MisTareas = lista;
            BindTareas();
        }

        // Metodos auxiliares para el Repeater: formatean textos y clases CSS
        // segun el estado de cada tarea

        protected string FormatearEstado(string estado)
        {
            switch (estado)
            {
                case "Pendiente": return "Pendiente";
                case "EnProgreso": return "En Progreso";
                case "Completada": return "Completada";
                default: return estado;
            }
        }

        protected string ObtenerTextoBotonEstado(string estado)
        {
            switch (estado)
            {
                case "Pendiente": return "Iniciar";
                case "EnProgreso": return "Completar";
                case "Completada": return "Reabrir";
                default: return "Cambiar";
            }
        }

        protected string ObtenerClaseBotonEstado(string estado)
        {
            switch (estado)
            {
                case "Pendiente": return "btn-primary";
                case "EnProgreso": return "btn-success";
                case "Completada": return "btn-danger";
                default: return "btn-primary";
            }
        }
    }
}
