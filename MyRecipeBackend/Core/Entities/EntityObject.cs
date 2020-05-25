using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Core.Contracts;

namespace Core.Entities
{
    public class EntityObject:IEntityObject
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
