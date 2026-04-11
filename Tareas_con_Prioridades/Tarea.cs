using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tareas_con_Prioridades
{
    [Serializable]
    public class Tarea
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public Prioridad Prioridad { get; set; }
        public EstadoTarea Estado { get; set; }
        public string Responsable { get; set; }
        public DateTime FechaCreacion { get; set; }
    }

    public enum Prioridad { Alta, Media, Baja }
    public enum EstadoTarea { Todos, Pendiente, EnProgreso, Completada }
}