using System;
using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public class EntityObject
    {
        [Key]
        public Guid Id { get; set; }

        [Timestamp]
        public byte[] RowVersion
        {
            get;
            set;
        }
    }
}
