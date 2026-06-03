import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { Cliente } from './cliente.entity';
import { Oportunidad } from './oportunidad.entity';
import { Actividad } from './actividad.entity';

@Entity('contacto')
export class Contacto {
  @PrimaryGeneratedColumn()
  id_contacto: number;

  @Column()
  id_cliente: number;

  @Column({ length: 120 })
  nombre_contacto: string;

  @Column({ length: 100, nullable: true })
  puesto_contacto: string;

  @Column({ length: 25, nullable: true })
  telefono: string;

  @Column({ length: 25, nullable: true })
  celular: string;

  @Column({ length: 120, nullable: true })
  correo_electronico: string;

  @Column({ default: true })
  estado: boolean;

  @Column({ type: 'datetime2', default: () => 'SYSDATETIME()' })
  fecha_creacion: Date;

  @ManyToOne(() => Cliente, (cliente) => cliente.contactos)
  cliente: Cliente;

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.contacto)
  oportunidades: Oportunidad[];

  @OneToMany(() => Actividad, (actividad) => actividad.contacto)
  actividades: Actividad[];
}
