using System;
using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public partial class InviteCode : EntityObject
    {
        [Required]
        public DateTime CreationDate { get; set; }

        [Required]
        [MinLength(6)]
        [MaxLength(6)]
        public string Code { get; set; }

        public Group Group { get; set; }


    }
}