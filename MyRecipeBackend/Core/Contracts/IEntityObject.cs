using System;

namespace Core.Contracts
{
    public interface IEntityObject
    {
        Guid Id { get; set; }
        byte[] RowVersion
        {
            get;
            set;
        }
    }
}