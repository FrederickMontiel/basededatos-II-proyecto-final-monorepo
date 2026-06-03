import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { RolUsuario } from './rol-usuario.entity';
import { Oportunidad } from './oportunidad.entity';
import { Actividad } from './actividad.entity';

@Entity('usuario_comercial')
export class UsuarioComercial {
  @PrimaryGeneratedColumn()
  id_usuario_comercial: number;

  @Column()
  id_rol_usuario: number;

  @Column({ length: 100 })
  nombres: string;

  @Column({ length: 100 })
  apellidos: string;

  @Column({ length: 120, unique: true })
  correo: string;

  @Column({ length: 255 })
  password_hash: string;

  @Column({ length: 25, nullable: true })
  telefono: string;

  @Column({ default: true })
  estado: boolean;

  @Column({ type: 'datetime2', nullable: true })
  ultimo_acceso: Date;

  @Column({ type: 'datetime2', default: () => 'SYSDATETIME()' })
  fecha_creacion: Date;

  @ManyToOne(() => RolUsuario, (rol) => rol.usuarios)
  rol: RolUsuario;

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.gestor)
  oportunidades_gestionadas: Oportunidad[];

  @OneToMany(() => Actividad, (actividad) => actividad.responsable)
  actividades: Actividad[];
}
