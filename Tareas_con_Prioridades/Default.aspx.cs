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

        // Punto 4 filtro activo
        private string FiltroActivo
        {
            get => ViewState["Filtro"] as string ?? "Todos";
            set => ViewState["Filtro"] = value;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            // El uso de IsPostBack 
            if (!IsPostBack)
            {
                BindTareas();
            }
        }

        private void BindTareas()
        {
            var tareasFiltradas = MisTareas;

            if (FiltroActivo != "Todos")
            {
                tareasFiltradas = MisTareas.Where(t => t.Estado.ToString() == FiltroActivo).ToList();
            }


        }


        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Tarea nueva = new Tarea
            {
                Id = MisTareas.Count + 1,
                // Asignar aquí el valor de los inputs (TextBox y DropDownList)
                Descripcion = "Tarea nueva desde lógica",
                Prioridad = Prioridad.Media,
                Estado = EstadoTarea.Pendiente,
                FechaCreacion = DateTime.Now
            };

            MisTareas.Add(nueva);
            BindTareas();

        }



        // Punto 6: Limpiar y Marcar completadas

        protected void rblFiltros_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Aqui asignar aquí el SelectedValue del RadioButtonList al FiltroActivo
            BindTareas();
        }
        protected void btnEliminarCompletadas_Click(object sender, EventArgs e)
        {
            MisTareas.RemoveAll(t => t.Estado == EstadoTarea.Completada);
            BindTareas();


    }
    }
}